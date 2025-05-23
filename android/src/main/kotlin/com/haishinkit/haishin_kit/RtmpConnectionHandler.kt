package com.haishinkit.haishin_kit

import com.haishinkit.event.Event
import com.haishinkit.event.IEventListener
import com.haishinkit.rtmp.RtmpConnection
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class RtmpConnectionHandler(
    private val plugin: HaishinKitPlugin
) : MethodChannel.MethodCallHandler, IEventListener, EventChannel.StreamHandler {
    companion object {
        private const val TAG = "RtmpConnection"
    }

    var instance: RtmpConnection? = RtmpConnection()
        private set(value) {
            field?.dispose()
            field = value
        }

    private var channel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
        set(value) {
            field?.endOfStream()
            field = value
        }

    init {
        instance?.addEventListener(Event.RTMP_STATUS, this)
        channel = EventChannel(
            plugin.flutterPluginBinding.binaryMessenger, "com.haishinkit.eventchannel/${hashCode()}"
        )
        channel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "$TAG#connect" -> {
                val command = call.argument<String>("command") ?: ""
                instance?.connect(command)
                result.success(null)
            }

            "$TAG#close" -> {
                instance?.close()
                result.success(null)
            }

            "$TAG#dispose" -> {
                eventSink = null
                instance = null
                plugin.onDispose(hashCode())
                result.success(null)
            }
        }
    }

    override fun handleEvent(event: Event) {
        val map = HashMap<String, Any?>()
        map["type"] = event.type
        map["data"] = event.data
        plugin.uiThreadHandler.post {
            eventSink?.success(map)
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
    }
}
