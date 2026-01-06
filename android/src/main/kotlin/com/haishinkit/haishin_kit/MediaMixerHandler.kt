package com.haishinkit.haishin_kit

import android.graphics.Rect
import android.util.Log
import com.haishinkit.media.MediaMixer
import com.haishinkit.media.MediaOutput
import com.haishinkit.media.source.AudioRecordSource
import com.haishinkit.media.source.AudioSource
import com.haishinkit.media.source.Camera2Source
import com.haishinkit.screen.ScreenObject.Companion.HORIZONTAL_ALIGNMENT_CENTER
import com.haishinkit.screen.ScreenObject.Companion.VERTICAL_ALIGNMENT_MIDDLE
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.serialization.json.Json

@Suppress("UNUSED")
class MediaMixerHandler(
    private val plugin: HaishinKitPlugin
) : MethodChannel.MethodCallHandler {
    companion object {
        private const val TAG = "MediaMixer"

        const val ILLEGAL_STATE = "ILLEGAL_STATE"
        const val INVALID_ARGUMENTS = "INVALID_ARGUMENTS"
    }

    private var mixer: MediaMixer? = null
        set(value) {
            field?.dispose()
            field = value
        }
    private var trackCameraMap: MutableMap<Int, Camera2Source> = mutableMapOf()
    private var audio: AudioSource? = null
    private var json = Json {
        ignoreUnknownKeys = true
    }

    init {
        mixer = MediaMixer(plugin.flutterPluginBinding.applicationContext)
        mixer?.screen?.let { screen ->
            screen.horizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER
            screen.verticalAlignment = VERTICAL_ALIGNMENT_MIDDLE
        }
    }

    fun registerOutput(output: MediaOutput) {
        mixer?.registerOutput(output)
    }

    fun unregisterOutput(output: MediaOutput) {
        mixer?.unregisterOutput(output)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "onMethodCall: " + call.method)
        when (call.method) {
            "$TAG#setAudioMixerSettings" -> {
                val value = call.argument<String>("value")
                if (value == null) {
                    result.error("INVALID_ARGUMENT", "value is null", null)
                } else {
                    val audioMixerSettings = json.decodeFromString<AudioMixerSettings>(value)
                    audio?.isMuted = audioMixerSettings.isMuted
                    result.success(null)
                }
            }

            "$TAG#setVideoMixerSettings" -> {
                val value = call.argument<String>("value")
                if (value == null) {
                    result.error("INVALID_ARGUMENT", "value is null", null)
                } else {
                    // not support yet.
                    result.success(null)
                }
            }

            "$TAG#setSessionPreset" -> {
                // for iOS
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
                val value = call.argument<String>("value")
                if (value == null) {
                    CoroutineScope(Dispatchers.Main).launch {
                        mixer?.attachVideo(track, null)
                        val camera = trackCameraMap.remove(track)
                        camera?.close()
                        result.success(null)
                    }
                } else {
                    val videoSource = json.decodeFromString<VideoSource>(value)
                    val cameraSource = Camera2Source(
                        plugin.flutterPluginBinding.applicationContext,
                        videoSource.id
                    )
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

            "$TAG#startRunning" -> {
                // for iOS, macOS
                result.success(null)
            }

            "$TAG#stopRunning" -> {
                // for iOS, macOS
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
                    mixer?.dispose()
                    mixer = null
                    trackCameraMap.clear()
                    plugin.onDispose(hashCode())
                    result.success(null)
                }
            }
        }
    }
}
