package com.haishinkit.haishin_kit

import android.content.Context
import android.graphics.Rect
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.media.MediaFormat.KEY_LEVEL
import android.media.MediaFormat.KEY_PROFILE
import android.os.Build
import android.util.Log
import android.util.Size
import android.view.WindowManager
import com.haishinkit.codec.CodecOption
import com.haishinkit.haishinkit.ProfileLevel
import com.haishinkit.media.MediaMixer
import com.haishinkit.media.source.AudioRecordSource
import com.haishinkit.media.source.Camera2Source
import com.haishinkit.rtmp.RtmpStream
import com.haishinkit.rtmp.event.Event
import com.haishinkit.rtmp.event.IEventListener
import com.haishinkit.screen.ScreenObject.Companion.HORIZONTAL_ALIGNMENT_CENTER
import com.haishinkit.screen.ScreenObject.Companion.VERTICAL_ALIGNMENT_MIDDLE
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class RtmpStreamHandler(
    private val plugin: HaishinKitPlugin, handler: RtmpConnectionHandler?
) : MethodChannel.MethodCallHandler, IEventListener, EventChannel.StreamHandler {
    private companion object {
        const val TAG = "RtmpStream"
    }

    private var rtmpStream: RtmpStream? = null
        set(value) {
            field?.dispose()
            field = value
        }
    private var mixer: MediaMixer? = null
        set(value) {
            field?.dispose()
            field = value
        }
    private var channel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
        set(value) {
            field?.endOfStream()
            field = value
        }
    private var camera: Camera2Source? = null
        set(value) {
            CoroutineScope(Dispatchers.Main).launch { field?.close() }
            field = value
        }
    private var texture: StreamViewTexture? = null

    init {
        handler?.instance?.let {
            rtmpStream = RtmpStream(plugin.flutterPluginBinding.applicationContext, it)
            rtmpStream!!.addEventListener(Event.RTMP_STATUS, this)
            mixer = MediaMixer(plugin.flutterPluginBinding.applicationContext)

            mixer?.screen?.let { screen ->
                screen.horizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER
                screen.verticalAlignment = VERTICAL_ALIGNMENT_MIDDLE
            }

            mixer?.registerOutput(rtmpStream!!)
        }
        channel = EventChannel(
            plugin.flutterPluginBinding.binaryMessenger, "com.haishinkit.eventchannel/${hashCode()}"
        )
        channel.setStreamHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall: " + call.method)
        when (call.method) {
            "$TAG#getHasAudio" -> {
                result.success(mixer?.hasAudio)
            }

            "$TAG#setHasAudio" -> {
                val value = call.argument<Boolean?>("value")
                value?.let { hasAudio ->
                    CoroutineScope(Dispatchers.Main).launch {
                        if (hasAudio) {
                            if (!mixer!!.hasAudio) {
                                mixer?.attachAudio(0, AudioRecordSource(plugin.flutterPluginBinding.applicationContext))
                            }
                        } else {
                            mixer?.attachAudio(0, null)
                        }
                        result.success(null)
                    }
                } ?: result.success(null)
            }

            "$TAG#getHasVideo" -> {
                result.success(null)
            }

            "$TAG#setHasVideo" -> {
                result.success(null)
            }

            "$TAG#setFrameRate" -> {
                val value = call.argument<Int?>("value")
                CoroutineScope(Dispatchers.Main).launch {
                    value?.let {
                        rtmpStream?.videoSetting?.frameRate = it
                    }
                }
                result.success(null)
            }

            "$TAG#setSessionPreset" -> {
                // for iOS
                result.success(null)
            }

            "$TAG#setAudioSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                (source["bitrate"] as? Int)?.let {
                    rtmpStream?.audioSetting?.bitRate = it
                }
                result.success(null)
            }

            "$TAG#setVideoSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                (source["width"] as? Int)?.let {
                    rtmpStream?.videoSetting?.width = it
                }
                (source["height"] as? Int)?.let {
                    rtmpStream?.videoSetting?.height = it
                }
                (source["frameInterval"] as? Int)?.let {
                    rtmpStream?.videoSetting?.IFrameInterval = it
                }
                (source["bitrate"] as? Int)?.let {
                    rtmpStream?.videoSetting?.bitRate = it
                }
                (source["profileLevel"] as? String)?.let {
                    try {
                        val profileLevel = ProfileLevel.valueOf(it)
                        val options = mutableListOf<CodecOption>()
                        options.add(CodecOption(KEY_PROFILE, profileLevel.profile))
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                          options.add(CodecOption(KEY_LEVEL, profileLevel.level))
                        }
                        rtmpStream?.videoSetting?.options = options
                    } catch (ignored: Exception) {
                        // Do nothing, use default setting
                    }
                }
                result.success(null)
            }

            "$TAG#setScreenSettings" -> {
                val source = call.argument<Map<String, Any?>>("settings") ?: return
                val frame = Rect(0, 0, 0, 0)
                (source["width"] as? Int)?.let {
                    frame.set(0, 0, it, frame.height())
                }
                (source["height"] as? Int)?.let {
                    frame.set(0, 0, frame.width(), it)
                }
                Log.d(TAG, "setScreenSettings $frame")
                mixer?.screen?.frame = frame

                result.success(null)
            }

            "$TAG#attachAudio" -> {
                val source = call.argument<Map<String, Any?>>("source")
                CoroutineScope(Dispatchers.Main).launch {
                    // Cleanup current attached source
                    mixer?.attachAudio(0, null)
                    if (source != null) {
                        mixer?.attachAudio(0, AudioRecordSource(plugin.flutterPluginBinding.applicationContext))
                    }
                    result.success(null)
                }
            }

            "$TAG#attachVideo" -> {
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    CoroutineScope(Dispatchers.Main).launch {
                        mixer?.attachVideo(0, null)
                        camera?.close()
                        camera = null
                        result.success(null)
                    }
                } else {
                    val facing = when (source["position"]) {
                        "front" -> CameraCharacteristics.LENS_FACING_FRONT
                        "back" -> CameraCharacteristics.LENS_FACING_BACK
                        else -> CameraCharacteristics.LENS_FACING_BACK
                    }
                    val cameraId = getCameraId(plugin.flutterPluginBinding.applicationContext, facing)
                    camera = if (cameraId != null) {
                        Camera2Source(plugin.flutterPluginBinding.applicationContext, cameraId)
                    } else {
                        Camera2Source(plugin.flutterPluginBinding.applicationContext)
                    }
                    CoroutineScope(Dispatchers.Main).launch {
                        camera?.let { cameraSource ->
                            mixer?.attachVideo(0, cameraSource)
                        }
                    }

                    result.success(null)
                }
            }

            "$TAG#registerTexture" -> {
                texture?.let { mixer?.unregisterOutput(it) }

                val texture = StreamViewTexture(plugin.flutterPluginBinding)
                mixer?.registerOutput(texture)
                this.texture = texture

                result.success(texture.id)
            }

            "$TAG#unregisterTexture" -> {
                texture?.let { mixer?.unregisterOutput(it) }
                
                result.success(null)
            }

            "$TAG#updateTextureSize" -> {
                if (rtmpStream == null) {
                    result.success(null)
                } else {
                    val width = call.argument<Double>("width") ?: 0
                    val height = call.argument<Double>("height") ?: 0
                    (plugin.flutterPluginBinding.applicationContext.getSystemService(Context.WINDOW_SERVICE) as? WindowManager)?.defaultDisplay?.orientation?.let {
                        camera?.video?.deviceOrientation = it
                    }
                    texture?.imageExtent = Size(width.toInt(), height.toInt())

                    result.success(texture?.id)
                }
            }

            "$TAG#publish" -> {
                rtmpStream?.publish(call.argument("name"))
                result.success(null)
            }

            "$TAG#play" -> {
                val name = call.argument<String>("name")
                if (name != null) {
                    rtmpStream?.play(name)
                }
                result.success(null)
            }

            "$TAG#close" -> {
                rtmpStream?.close()
                result.success(null)
            }

            "$TAG#dispose" -> {
                // Explicitly detach video before disposal
                CoroutineScope(Dispatchers.Main).launch {
                    mixer?.attachVideo(0, null)
                    mixer?.attachAudio(0, null)

                    // Properly disconnect mixer from RTMP stream before disposal
                    rtmpStream?.let { stream ->
                        mixer?.unregisterOutput(stream)
                    }
                    texture?.dispose()
                    mixer?.dispose()
                    rtmpStream?.dispose()

                    mixer = null
                    eventSink = null
                    camera = null
                    rtmpStream = null
                    plugin.onDispose(hashCode())
                    result.success(null)
                }
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

    /**
     * Finds the camera ID for a camera with the specified facing direction.
     *
     * @param context The application context
     * @param desiredFacing The desired camera facing direction (CameraCharacteristics.LENS_FACING_FRONT or LENS_FACING_BACK)
     * @return The camera ID string, or null if no camera with the specified facing is found
     */
    private fun getCameraId(context: Context, desiredFacing: Int): String? {
        val cameraManager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        for (cameraId in cameraManager.cameraIdList) {
            val characteristics = cameraManager.getCameraCharacteristics(cameraId)
            val facing = characteristics.get(CameraCharacteristics.LENS_FACING)
            if (facing != null && facing == desiredFacing) {
                return cameraId
            }
        }
        return null
    }
}
