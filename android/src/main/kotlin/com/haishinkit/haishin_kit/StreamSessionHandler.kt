package com.haishinkit.haishin_kit

import android.util.Log
import com.haishinkit.graphics.DynamicRangeMode
import com.haishinkit.stream.StreamSession
import com.haishinkit.view.StreamView
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json

class StreamSessionHandler(
    private val plugin: HaishinKitPlugin,
    var session: StreamSession?,
    val dynamicRangeMode: DynamicRangeMode = DynamicRangeMode.SDR,
    private val protocol: String = "rtmp",
) : MethodChannel.MethodCallHandler, EventChannel.StreamHandler {
    companion object Companion {
        private const val TAG = "StreamSession"
        const val CONNECT_FAILED = "CONNECT_FAILED"
    }

    private var channel = EventChannel(
        plugin.flutterPluginBinding.binaryMessenger, "com.haishinkit.eventchannel/${hashCode()}"
    )
    private var eventSink: EventChannel.EventSink? = null
        set(value) {
            field?.endOfStream()
            field = value
        }
    private var texture: StreamViewTexture? = null
        set(value) {
            field?.let {
                session?.stream?.unregisterOutput(it)
            }
            field?.dispose()
            field = value
        }
    private var json = Json {
        ignoreUnknownKeys = true
    }
    private var scope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    init {
        channel.setStreamHandler(this)
        session?.readyState?.onEach { state ->
            eventSink?.success(state.toString().lowercase())
        }?.launchIn(scope)
    }

    internal fun registerHdrView(view: StreamView) {
        require(dynamicRangeMode == DynamicRangeMode.HLG) { "A native HDR view requires an HLG session" }
        requireNotNull(session) { "The stream session is disposed" }.stream.registerOutput(view)
    }

    internal fun unregisterHdrView(view: StreamView) {
        session?.stream?.unregisterOutput(view)
        view.dataSource = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall: " + call.method + "()")
        if (session == null) {
            result.error(HaishinKitPlugin.ILLEGAL_STATE, "session is disposed.", null)
            return
        }
        when (call.method) {
            "$TAG#setFrameRate" -> {
                val value = call.argument<Int?>("value")
                if (value == null) {
                    result.error(HaishinKitPlugin.INVALID_ARGUMENTS, null, null)
                } else {
                    session?.stream?.videoSetting?.frameRate = value
                    result.success(null)
                }
            }
            "$TAG#setAudioSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings")
                if (source == null) {
                    result.error(HaishinKitPlugin.INVALID_ARGUMENTS, null, null)
                } else {
                    (source["bitrate"] as? Int)?.let {
                        session?.stream?.audioSetting?.bitRate = it
                    }
                    result.success(null)
                }
            }

            "$TAG#setVideoSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings")
                if (source == null) {
                    result.error(HaishinKitPlugin.INVALID_ARGUMENTS, "Video settings are required", null)
                    return
                }
                try {
                    val activeSession = requireNotNull(session)
                    val settings = activeSession.stream.videoSetting
                    val profile = if (source["codec"] == null && source["profileLevel"] == null) {
                        settings.profileLevel
                    } else NativeVideoCodecs.profile(
                        source["codec"] as? String ?: "h264",
                        source["profileLevel"] as? String ?: settings.profileLevel.takeIf { it.mime == "video/avc" }?.rawValue,
                        dynamicRangeMode,
                        protocol,
                    )
                    require(activeSession.readyState.value == StreamSession.ReadyState.CLOSED ||
                        (profile == settings.profileLevel &&
                            (source["width"] == null || source["width"] == settings.width) &&
                            (source["height"] == null || source["height"] == settings.height) &&
                            (source["frameInterval"] == null || source["frameInterval"] == settings.IFrameInterval))) {
                        "Close the session before changing video dimensions, codec or profile"
                    }
                    settings.profileLevel = profile
                (source["width"] as? Int)?.let {
                    session?.stream?.videoSetting?.width = it
                }
                (source["height"] as? Int)?.let {
                    session?.stream?.videoSetting?.height = it
                }
                (source["frameInterval"] as? Int)?.let {
                    session?.stream?.videoSetting?.IFrameInterval = it
                }
                (source["bitrate"] as? Int)?.let {
                    session?.stream?.videoSetting?.bitRate = it
                }
                result.success(null)
                } catch (error: Exception) {
                    result.error(HaishinKitPlugin.INVALID_ARGUMENTS, error.message, null)
                }
            }

            "$TAG#registerTexture" -> {
                if (dynamicRangeMode == DynamicRangeMode.HLG) {
                    result.error(HaishinKitPlugin.INVALID_ARGUMENTS, "HLG previews require a native HDR view", null)
                    return
                }
                val texture = StreamViewTexture(plugin.flutterPluginBinding)
                this.texture = texture
                session?.stream?.registerOutput(texture)
                result.success(texture.id)
            }

            "$TAG#unregisterTexture" -> {
                texture = null
                result.success(null)
            }

            "$TAG#updateTexture" -> {
                val value = call.argument<String>("value")
                if (value == null) {
                    result.error("INVALID_ARGUMENT", "value is null", null)
                } else {
                    val snapshot = json.decodeFromString<StreamViewTextureSnapshot>(value)
                    texture?.imageExtent = snapshot.size
                    texture?.videoGravity = snapshot.videoGravity
                    result.success(texture?.id)
                }
            }

            "$TAG#connect" -> {
                scope.launch {
                    session?.connect()?.onSuccess {
                        result.success(null)
                    }?.onFailure {
                        result.error(CONNECT_FAILED, it.message, null)
                    }
                }
            }

            "$TAG#close" -> {
                scope.launch {
                    session?.close()
                    result.success(null)
                }
            }

            "$TAG#dispose" -> {
                plugin.onDispose(hashCode())
                texture = null
                val activeSession = session
                session = null
                scope.launch {
                    try {
                        activeSession?.close()
                    } finally {
                        activeSession?.stream?.dispose()
                        channel.setStreamHandler(null)
                        eventSink = null
                        result.success(null)
                        scope.cancel()
                    }
                }
            }
        }
    }

    override fun onListen(
        arguments: Any?, events: EventChannel.EventSink?
    ) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
