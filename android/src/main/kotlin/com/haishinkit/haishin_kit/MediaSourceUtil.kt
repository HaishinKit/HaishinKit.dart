package com.haishinkit.haishin_kit

import android.content.Context
import android.hardware.camera2.CameraCharacteristics
import android.hardware.camera2.CameraManager
import android.hardware.camera2.CameraMetadata

object MediaSourceUtil {
    fun getVideoSources(context: Context): List<VideoSource> {
        val manager = context.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        return manager.cameraIdList.map {
            val characteristics = manager.getCameraCharacteristics(it)
            val position = when (characteristics.get(CameraCharacteristics.LENS_FACING)) {
                CameraMetadata.LENS_FACING_BACK -> VideoSource.CameraPosition.BACK
                CameraMetadata.LENS_FACING_FRONT -> VideoSource.CameraPosition.FRONT
                CameraMetadata.LENS_FACING_EXTERNAL -> VideoSource.CameraPosition.UNSPECIFIED
                else -> VideoSource.CameraPosition.UNSPECIFIED
            }
            VideoSource(
                id = it.toString(),
                name = null,
                position = position
            )
        }
    }
}