package com.haishinkit.haishin_kit

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class VideoSource(
    val id: String,
    val name: String?,
    val position: CameraPosition
) {
    enum class CameraPosition {
        @SerialName("front")
        FRONT,

        @SerialName("back")
        BACK,

        @SerialName("unspecified")
        UNSPECIFIED
    }
}