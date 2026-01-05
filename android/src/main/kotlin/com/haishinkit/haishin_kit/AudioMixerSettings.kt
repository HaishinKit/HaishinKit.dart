package com.haishinkit.haishin_kit

import kotlinx.serialization.Serializable

@Serializable
data class AudioMixerSettings(
    val isMuted: Boolean
)