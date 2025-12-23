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
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.ProcessLifecycleOwner
import com.haishinkit.codec.CodecOption
import com.haishinkit.haishinkit.ProfileLevel
import com.haishinkit.media.MediaMixer
import com.haishinkit.media.source.AudioRecordSource
import com.haishinkit.media.source.AudioSource
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
) : MethodChannel.MethodCallHandler, IEventListener, EventChannel.StreamHandler,
    DefaultLifecycleObserver {
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
    private var trackCameraMap: MutableMap<Int, Camera2Source> = mutableMapOf()
    private var audio: AudioSource? = null
    private var shouldReattach = false

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
                    audio?.isMuted = !hasAudio
                }
                result.success(null)
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
                    audio?.close()
                    audio = null

                    if (source != null) {
                        audio = AudioRecordSource(plugin.flutterPluginBinding.applicationContext)
                        mixer?.attachAudio(0, audio)
                    }
                    result.success(null)
                }
            }

            "$TAG#attachVideo" -> {
                val track = call.argument<Int?>("track")
                if (track == null) {
                    result.error("INVALID_ARGUMENT", "track is null", null)
                    return
                }
                val source = call.argument<Map<String, Any?>>("source")
                if (source == null) {
                    CoroutineScope(Dispatchers.Main).launch {
                        mixer?.attachVideo(track, null)
                        val camera = trackCameraMap.remove(track)
                        camera?.close()
                        result.success(null)
                    }
                } else {
                    val cameraId = source["id"] as String?
                    val cameraSource = if (cameraId != null) {
                        Camera2Source(plugin.flutterPluginBinding.applicationContext, cameraId)
                    } else {
                        Camera2Source(plugin.flutterPluginBinding.applicationContext)
                    }
                    CoroutineScope(Dispatchers.Main).launch {
                        // Detach current video source
                        mixer?.attachVideo(track, null)
                        val oldCamera = trackCameraMap.remove(track)
                        oldCamera?.close()

                        trackCameraMap[track] = cameraSource
                        mixer?.attachVideo(track, cameraSource)
                        result.success(null)
                    }
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
                    Log.d(TAG, "Update device orientation")
                    (plugin.flutterPluginBinding.applicationContext.getSystemService(Context.WINDOW_SERVICE) as? WindowManager)?.defaultDisplay?.orientation?.let {
                        for (camera in trackCameraMap.values) {
                            camera.video?.deviceOrientation = it
                        }
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
                    mixer?.attachAudio(0, null)
                    for ((track, camera) in trackCameraMap) {
                        mixer?.attachVideo(track, null)
                        camera.close()
                    }

                    // Properly disconnect mixer from RTMP stream before disposal
                    rtmpStream?.let { stream ->
                        mixer?.unregisterOutput(stream)
                    }
                    texture?.dispose()
                    mixer?.dispose()
                    rtmpStream?.dispose()

                    mixer = null
                    eventSink = null
                    trackCameraMap.clear()
                    audio = null
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

        ProcessLifecycleOwner.get().lifecycle.addObserver(this)
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null

        ProcessLifecycleOwner.get().lifecycle.removeObserver(this)
    }

    override fun onPause(owner: LifecycleOwner) {
        shouldReattach = true

        texture?.let { mixer?.unregisterOutput(it) }
        CoroutineScope(Dispatchers.Main).launch {
            mixer?.attachVideo(0, null)
        }
        super.onPause(owner)
    }

    override fun onResume(owner: LifecycleOwner) {
        super.onResume(owner)

        if (!shouldReattach) return
        texture?.let { mixer?.registerOutput(it) }
        CoroutineScope(Dispatchers.Main).launch {
            for ((track, camera) in trackCameraMap) {
                camera.let { mixer?.attachVideo(track, it) }
            }
            shouldReattach = false
        }
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
            Log.d(TAG, "Camera ID: $cameraId; facing: $facing")
            if (facing != null && facing == desiredFacing) {
                return cameraId
            }
        }
        return null
    }
}
