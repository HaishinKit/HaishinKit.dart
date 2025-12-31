package com.haishinkit.haishin_kit

import android.media.MediaFormat.KEY_LEVEL
import android.media.MediaFormat.KEY_PROFILE
import android.os.Build
import android.util.Log
import android.util.Size
import com.haishinkit.codec.CodecOption
import com.haishinkit.haishinkit.ProfileLevel
import com.haishinkit.stream.StreamSession
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SessionHandler(
    private val plugin: HaishinKitPlugin,
    var session: StreamSession?,
    var mode: String
) : MethodChannel.MethodCallHandler,
    EventChannel.StreamHandler {
    companion object {
        private const val TAG = "Session"
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

    init {
        channel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall: " + call.method)
        when (call.method) {
            "$TAG#setFrameRate" -> {
                val value = call.argument<Int?>("value")
                CoroutineScope(Dispatchers.Main).launch {
                    value?.let {
                        session?.stream?.videoSetting?.frameRate = it
                    }
                }
                result.success(null)
            }

            "$TAG#setAudioSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                (source["bitrate"] as? Int)?.let {
                    session?.stream?.audioSetting?.bitRate = it
                }
                result.success(null)
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
                if (session == null) {
                    result.success(null)
                } else {
                    val width = call.argument<Double>("width") ?: 0
                    val height = call.argument<Double>("height") ?: 0
                    texture?.imageExtent = Size(width.toInt(), height.toInt())
                    result.success(texture?.id)
                }
            }

            "$TAG#connect" -> {
                CoroutineScope(Dispatchers.Main).launch {
                    if (mode == "publish") {
                        session?.connect(StreamSession.Method.INGEST)
                    } else {
                        session?.connect(StreamSession.Method.PLAYBACK)
                    }
                    result.success(null)
                }
            }

            "$TAG#close" -> {
                CoroutineScope(Dispatchers.Main).launch {
                    session?.close()
                    result.success(null)
                }
            }

            "$TAG#dispose" -> {
                // Explicitly detach video before disposal
                CoroutineScope(Dispatchers.Main).launch {
                    plugin.onDispose(hashCode())
                    texture = null
                    session = null
                    result.success(null)
                }
            }
        }
    }

    override fun onListen(
        arguments: Any?,
        events: EventChannel.EventSink?
    ) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }
}
