package com.haishinkit.haishin_kit

import android.os.Handler
import android.os.Looper
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

    fun onDispose(id: Int) {
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
            "newRtmpConnection" -> {
                val handler = RtmpConnectionHandler(this)
                handlers[handler.hashCode()] = handler
                result.success(handler.hashCode())
            }

            "newRtmpStream" -> {
                val connection = call.argument<Int>("connection")
                val handler =
                    RtmpStreamHandler(this, handlers[connection] as? RtmpConnectionHandler)
                handlers[handler.hashCode()] = handler
                result.success(handler.hashCode())
            }

            "getPlatformVersion" -> {
                result.success(com.haishinkit.BuildConfig.LIBRARY_PACKAGE_NAME)
            }

            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
