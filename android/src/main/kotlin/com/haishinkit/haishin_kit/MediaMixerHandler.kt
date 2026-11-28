package com.haishinkit.haishin_kit

import android.graphics.Rect
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.hardware.camera2.params.DynamicRangeProfiles
import android.os.Build
import android.util.Log
import androidx.lifecycle.ProcessLifecycleOwner
import com.haishinkit.device.CameraDevice
import com.haishinkit.graphics.DynamicRangeMode
import com.haishinkit.media.AudioMixerSettings
import com.haishinkit.media.MediaMixer
import com.haishinkit.media.MediaOutput
import com.haishinkit.media.source.AudioRecordSource
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
    private var plugin: HaishinKitPlugin,
    val dynamicRangeMode: DynamicRangeMode = DynamicRangeMode.SDR,
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
        mixer = MediaMixer(plugin.flutterPluginBinding.applicationContext, dynamicRangeMode)
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

    fun createScreenHandler(): ScreenHandler {
        return ScreenHandler(plugin, mixer?.screen)
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
                            0, AudioRecordSource(plugin.flutterPluginBinding.applicationContext).apply { (source["sampleRate"] as? Int)?.let { sampleRate = it } }
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
                        try {
                            val videoSource = json.decodeFromString<CameraDevice>(value)
                            if (dynamicRangeMode == DynamicRangeMode.HLG && Build.VERSION.SDK_INT >= 33) {
                                val manager = requireNotNull(plugin.flutterPluginBinding.applicationContext
                                    .getSystemService(CameraManager::class.java)) { "Camera service is unavailable" }
                                val profiles = manager.getCameraCharacteristics(videoSource.id)
                                    .get(CameraCharacteristics.REQUEST_AVAILABLE_DYNAMIC_RANGE_PROFILES)
                                require(profiles?.supportedProfiles?.contains(DynamicRangeProfiles.HLG10) == true) {
                                    "Camera ${videoSource.id} does not support HLG capture"
                                }
                            }
                            val cameraSource = Camera2Source(
                                plugin.flutterPluginBinding.applicationContext, videoSource.id,
                                dynamicRangeMode = dynamicRangeMode,
                            )
                            mixer?.attachVideo(track, cameraSource)?.getOrThrow()
                            result.success(null)
                        } catch (error: Exception) {
                            result.error("FAILED_TO_ATTACH", error.message, null)
                        }
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
