package com.haishinkit.haishin_kit

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraMetadata
import android.os.Handler
import android.os.Looper
import androidx.core.net.toUri
import com.haishinkit.media.MediaOutput
import com.haishinkit.rtmp.RtmpStreamSessionFactory
import com.haishinkit.stream.StreamSession
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.ConcurrentHashMap

class HaishinKitPlugin : FlutterPlugin, MethodCallHandler {
    companion object {
        private const val CHANNEL_NAME = "com.haishinkit"
    }

    lateinit var flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    val uiThreadHandler = Handler(Looper.getMainLooper())
    private lateinit var channel: MethodChannel
    private var handlers = ConcurrentHashMap<Int, MethodCallHandler>()

    init {
        StreamSession.Builder.registerFactory(RtmpStreamSessionFactory)
    }

    fun onDispose(id: Int) {
        (handlers[id] as? SessionHandler)?.let { handler ->
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
                val handler = MediaMixerHandler(this)
                handlers[handler.hashCode()] = handler
                result.success(handler.hashCode())
            }

            "newSession" -> {
                val url = call.argument<String?>("url")
                val mode = call.argument<String?>("mode")
                if (url != null && mode != null) {
                    val session =
                        StreamSession.Builder(flutterPluginBinding.applicationContext, url.toUri())
                            .build()
                    if (mode == "publish") {
                        registerOutput(session.stream)
                    }
                    val handler = SessionHandler(this, session, mode)
                    handlers[handler.hashCode()] = handler
                    result.success(handler.hashCode())
                } else {
                    result.notImplemented()
                }
            }

            "getPlatformVersion" -> {
                result.success(com.haishinkit.BuildConfig.LIBRARY_PACKAGE_NAME)
            }

            "getVideoSources" -> {
                val context = flutterPluginBinding.applicationContext
                val manager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
                val idList = manager.getCameraIdList()
                result.success(idList.map {
                    val characteristics = manager.getCameraCharacteristics(it)
                    val position = when (characteristics.get(CameraCharacteristics.LENS_FACING)) {
                        CameraMetadata.LENS_FACING_BACK -> "back"
                        CameraMetadata.LENS_FACING_FRONT -> "front"
                        CameraMetadata.LENS_FACING_EXTERNAL -> "unspecified"
                        else -> "unspecified"
                    }
                    mapOf("id" to it, "position" to position)
                })
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun registerOutput(output: MediaOutput) {
        for (handler in handlers.values) {
            (handler as? MediaMixerHandler)?.let {
                handler.registerOutput(output)
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
