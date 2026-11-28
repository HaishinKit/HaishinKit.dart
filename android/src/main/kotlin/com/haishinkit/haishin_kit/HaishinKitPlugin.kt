package com.haishinkit.haishin_kit

import android.os.Build
import androidx.core.net.toUri
import com.haishinkit.device.CameraDeviceManager
import com.haishinkit.graphics.DynamicRangeMode
import com.haishinkit.media.MediaOutput
import com.haishinkit.rtc.HttpStreamSessionFactory
import com.haishinkit.rtmp.RtmpStreamSessionFactory
import com.haishinkit.srt.SrtStreamSessionFactory
import com.haishinkit.stream.StreamSession
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.serialization.ExperimentalSerializationApi
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive
import java.util.concurrent.ConcurrentHashMap

class HaishinKitPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    companion object {
        private const val CHANNEL_NAME = "com.haishinkit"

        const val ILLEGAL_STATE = "ILLEGAL_STATE"
        const val INVALID_ARGUMENTS = "INVALID_ARGUMENTS"
    }

    lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    private var handlers = ConcurrentHashMap<Int, MethodCallHandler>()
    private lateinit var channel: MethodChannel

    private lateinit var deviceManager: CameraDeviceManager
    private val hdrViews = HdrViewFactory(this)

    @OptIn(ExperimentalSerializationApi::class)
    private var json = Json {
        decodeEnumsCaseInsensitive = true
    }

    init {
        StreamSession.Builder.registerFactory(RtmpStreamSessionFactory)
        StreamSession.Builder.registerFactory(SrtStreamSessionFactory)
        StreamSession.Builder.registerFactory(HttpStreamSessionFactory())
    }

    fun onDispose(id: Int) {
        (handlers[id] as? StreamSessionHandler)?.let { handler ->
            hdrViews.disposeSession(handler)
            handler.session?.stream?.let {
                unregisterOutput(it)
            }
        }
        handlers.remove(id)
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
        deviceManager = CameraDeviceManager(flutterPluginBinding.applicationContext)
        flutterPluginBinding.platformViewRegistry.registerViewFactory("com.haishinkit.hdr", hdrViews)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        val memory = call.argument<Int>("memory")
        if (memory != null) {
            val handler = handlers[memory]
            if (handler != null) {
                handler.onMethodCall(call, result)
            } else {
                result.notImplemented()
            }
            return
        }
        when (call.method) {
            "newMediaMixer" -> {
                try {
                    val options = call.argument<String>("value")?.let { json.parseToJsonElement(it).jsonObject }
                    val range = parseRange(options?.get("dynamicRangeMode")?.jsonPrimitive?.content)
                    val handler = MediaMixerHandler(this, range)
                    handlers[handler.hashCode()] = handler
                    result.success(handler.hashCode())
                } catch (error: Exception) {
                    result.error(INVALID_ARGUMENTS, error.message, null)
                }
            }

            "newSession" -> {
                val url = call.argument<String?>("url")
                val mode = call.argument<String?>("mode")
                if (url != null && mode != null) {
                    try {
                        val range = parseRange(call.argument<String>("dynamicRangeMode"))
                        val uri = url.toUri()
                        val sessionMode = when (mode) {
                            "publish" -> StreamSession.Mode.PUBLISH
                            "playback" -> StreamSession.Mode.PLAYBACK
                            else -> throw IllegalArgumentException("Unknown session mode: $mode")
                        }
                        require(range == DynamicRangeMode.SDR || uri.scheme in setOf("rtmp", "rtmps")) {
                            "HLG sessions require an RTMP URL"
                        }
                        val context = flutterPluginBinding.applicationContext
                        val session = if (range == DynamicRangeMode.HLG) {
                            RtmpStreamSessionFactory.create(context, uri, sessionMode, range)
                        } else {
                            StreamSession.Builder(context, uri).setMode(sessionMode).build()
                        }
                        if (mode == "publish") registerOutput(session.stream, range)
                        val handler = StreamSessionHandler(this, session, range, uri.scheme.orEmpty())
                        handlers[handler.hashCode()] = handler
                        result.success(handler.hashCode())
                    } catch (error: Exception) {
                        result.error(INVALID_ARGUMENTS, error.message, null)
                    }
                } else {
                    result.notImplemented()
                }
            }

            "newScreen" -> {
                val mixer = call.argument<Int>("mixer")
                val handler = (handlers[mixer] as? MediaMixerHandler)?.createScreenHandler()
                if (handler == null) {
                    result.notImplemented()
                } else {
                    handlers[handler.hashCode()] = handler
                    result.success(handler.hashCode())
                }
            }

            "getPlatformVersion" -> {
                result.success(com.haishinkit.BuildConfig.LIBRARY_PACKAGE_NAME)
            }

            "getVideoSources" -> {
                val sources = deviceManager.getDeviceList()
                result.success(json.encodeToString(sources))
            }

            "getSupportedVideoCodecs" -> {
                try {
                    result.success(NativeVideoCodecs.supported(parseRange(call.argument<String>("dynamicRangeMode"), false)))
                } catch (error: Exception) {
                    result.error(INVALID_ARGUMENTS, error.message, null)
                }
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        hdrViews.dispose()
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        hdrViews.setWindow(binding.activity.window)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    override fun onDetachedFromActivity() {
        hdrViews.setWindow(null)
    }

    internal fun sessionHandler(memory: Int): StreamSessionHandler? = handlers[memory] as? StreamSessionHandler

    private fun parseRange(value: String?, requireSupport: Boolean = true): DynamicRangeMode {
        val range = when (value ?: "sdr") {
            "sdr" -> DynamicRangeMode.SDR
            "hlg" -> DynamicRangeMode.HLG
            else -> throw IllegalArgumentException("Unknown dynamic range: $value")
        }
        require(!requireSupport || range == DynamicRangeMode.SDR || Build.VERSION.SDK_INT >= 33) { "HLG requires Android 13 or newer" }
        return range
    }

    private fun registerOutput(output: MediaOutput, range: DynamicRangeMode) {
        for (handler in handlers.values) {
            (handler as? MediaMixerHandler)?.let {
                if (handler.dynamicRangeMode == range) handler.registerOutput(output)
            }
        }
    }

    private fun unregisterOutput(output: MediaOutput) {
        for (handler in handlers.values) {
            (handler as? MediaMixerHandler)?.let {
                handler.unregisterOutput(output)
            }
        }
    }
}
