package com.haishinkit.haishin_kit

import android.media.MediaFormat.KEY_LEVEL
import android.media.MediaFormat.KEY_PROFILE
import android.os.Build
import android.util.Log
import android.util.Size
import com.haishinkit.codec.CodecOption
import com.haishinkit.stream.StreamSession
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

class StreamSessionHandler(
    private val plugin: HaishinKitPlugin,
    var session: StreamSession?,
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
    private var scope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    init {
        channel.setStreamHandler(this)
        session?.readyState?.onEach { state ->
            eventSink?.success(state.toString().lowercase())
        }?.launchIn(scope)
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
                val source = call.argument<Map<String, Any?>>("settings") ?: return
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
                (source["profileLevel"] as? String)?.let {
                    try {
                        val profileLevel = ProfileLevel.valueOf(it)
                        val options = mutableListOf<CodecOption>()
                        options.add(CodecOption(KEY_PROFILE, profileLevel.profile))
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            options.add(CodecOption(KEY_LEVEL, profileLevel.level))
                        }
                        session?.stream?.videoSetting?.options = options
                    } catch (ignored: Exception) {
                        // Do nothing, use default setting
                    }
                }
                result.success(null)
            }

            "$TAG#registerTexture" -> {
                val texture = StreamViewTexture(plugin.flutterPluginBinding)
                this.texture = texture
                session?.stream?.registerOutput(texture)
                result.success(texture.id)
            }

            "$TAG#unregisterTexture" -> {
                texture = null
                result.success(null)
            }

            "$TAG#updateTextureSize" -> {
                val width = call.argument<Double>("width") ?: 0
                val height = call.argument<Double>("height") ?: 0
                texture?.imageExtent = Size(width.toInt(), height.toInt())
                result.success(texture?.id)
            }

            "$TAG#connect" -> {
                scope.launch {
                    session?.connect()?.onSuccess {
                        result.success(null)
                    }?.onFailure {
                        result.error(CONNECT_FAILED, null, null)
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
                session = null
                scope.cancel()
                result.success(null)
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
