package com.haishinkit.haishin_kit

import android.graphics.Rect
import android.util.Log
import androidx.lifecycle.ProcessLifecycleOwner
import com.haishinkit.device.CameraDevice
import com.haishinkit.media.MediaMixer
import com.haishinkit.media.MediaOutput
import com.haishinkit.media.source.AudioRecordSource
import com.haishinkit.media.AudioMixerSettings
import com.haishinkit.media.source.Camera2Source
import com.haishinkit.screen.ScreenObject.Companion.HORIZONTAL_ALIGNMENT_CENTER
import com.haishinkit.screen.ScreenObject.Companion.VERTICAL_ALIGNMENT_MIDDLE
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
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
    private var json = Json {
        ignoreUnknownKeys = true
    }

    private var scope: CoroutineScope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)

    init {
        mixer = MediaMixer(plugin.flutterPluginBinding.applicationContext)
        mixer?.screen?.let { screen ->
            screen.horizontalAlignment = HORIZONTAL_ALIGNMENT_CENTER
            screen.verticalAlignment = VERTICAL_ALIGNMENT_MIDDLE
        }
        mixer?.let {
            ProcessLifecycleOwner.get().lifecycle.addObserver(it)
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
                    mixer?.audioMixerSettings = audioMixerSettings
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

                if (source == null) {
                    scope.launch {
                        mixer?.attachAudio(0, null)
                        result.success(null)
                    }
                } else {
                    scope.launch {
                        mixer?.attachAudio(
                            0, AudioRecordSource(plugin.flutterPluginBinding.applicationContext)
                        )
                        result.success(null)
                    }
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
                    scope.launch {
                        mixer?.attachVideo(track, null)
                        result.success(null)
                    }
                } else {
                    scope.launch {
                        val videoSource = json.decodeFromString<CameraDevice>(value)
                        val cameraSource = Camera2Source(
                            plugin.flutterPluginBinding.applicationContext, videoSource.id
                        )
                        mixer?.attachVideo(track, cameraSource)
                        result.success(null)
                    }
                }
            }

            "$TAG#startRunning" -> {
                scope.launch {
                    mixer?.startRunning()
                    result.success(null)
                }
            }

            "$TAG#stopRunning" -> {
                scope.launch {
                    mixer?.stopRunning()
                    result.success(null)
                }
            }

            "$TAG#dispose" -> {
                plugin.onDispose(hashCode())
                scope.cancel()
                mixer?.let {
                    ProcessLifecycleOwner.get().lifecycle.removeObserver(it)
                }
                mixer = null
                result.success(null)
            }
        }
    }
}
