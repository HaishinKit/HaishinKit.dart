package com.haishinkit.haishin_kit

import android.util.Size
import com.haishinkit.graphics.VideoGravity
import kotlinx.serialization.Serializable

@Serializable
data class StreamViewTextureSnapshot(
    val width: Double,
    val height: Double,
    val videoGravity: VideoGravity
) {
    val size: Size
        get() = Size(width.toInt(), height.toInt())
}
