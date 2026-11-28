package com.haishinkit.haishin_kit

import android.media.MediaCodecInfo
import android.media.MediaCodecList
import android.os.Build
import com.haishinkit.codec.VideoCodecProfileLevel
import com.haishinkit.graphics.DynamicRangeMode

/** Uses only encoders installed by the OS. No codec implementations are bundled. */
internal object NativeVideoCodecs {
    private val mimeTypes = linkedMapOf(
        "h264" to "video/avc",
        "hevc" to "video/hevc",
        "av1" to "video/av01",
        "vp8" to "video/x-vnd.on2.vp8",
        "vp9" to "video/x-vnd.on2.vp9",
    )

    fun supported(range: DynamicRangeMode): List<String> {
        if (range == DynamicRangeMode.HLG && Build.VERSION.SDK_INT < 33) return emptyList()
        val encoders = MediaCodecList(MediaCodecList.REGULAR_CODECS).codecInfos.filter { it.isEncoder }
        return mimeTypes.filter { (name, mime) ->
            if (name == "av1" && Build.VERSION.SDK_INT < 29) return@filter false
            if (range == DynamicRangeMode.HLG && name !in setOf("hevc", "av1")) return@filter false
            encoders.any { encoder ->
                runCatching {
                    if (!encoder.supportedTypes.any { it.equals(mime, ignoreCase = true) }) return@runCatching false
                    val capabilities = encoder.getCapabilitiesForType(mime)
                    if (MediaCodecInfo.CodecCapabilities.COLOR_FormatSurface !in capabilities.colorFormats) {
                        return@runCatching false
                    }
                    if (range == DynamicRangeMode.SDR) return@runCatching true
                    val profile = if (name == "hevc") {
                        MediaCodecInfo.CodecProfileLevel.HEVCProfileMain10
                    } else {
                        MediaCodecInfo.CodecProfileLevel.AV1ProfileMain10
                    }
                    Build.VERSION.SDK_INT >= 33 &&
                        (capabilities.isFeatureSupported(MediaCodecInfo.CodecCapabilities.FEATURE_HdrEditing) ||
                            capabilities.isFeatureSupported("hlg-editing")) &&
                        capabilities.profileLevels.any { it.profile == profile }
                }.getOrDefault(false)
            }
        }.keys.toList()
    }

    fun profile(codec: String, h264Profile: String?, range: DynamicRangeMode, protocol: String): VideoCodecProfileLevel {
        val allowed = when (protocol.lowercase()) {
            "rtmp", "rtmps" -> mimeTypes.keys
            "srt" -> setOf("h264")
            "http", "https" -> setOf("h264", "vp8", "vp9")
            else -> emptySet()
        }
        require(codec in allowed) { "$codec publishing is not supported by $protocol" }
        require(range == DynamicRangeMode.SDR || protocol.lowercase() in setOf("rtmp", "rtmps")) {
            "HLG publishing requires RTMP"
        }
        require(codec in supported(range)) { "No OS surface encoder supports $codec with ${range.name}" }
        val rawValue = when (codec) {
            "h264" -> h264Profile ?: "H264_Baseline_3_1"
            "hevc" -> if (range == DynamicRangeMode.HLG) "HEVC_Main10_4_1" else "HEVC_Main_4_1"
            "av1" -> if (range == DynamicRangeMode.HLG) "AV1_Main10_4_1" else "AV1_Main8_4_1"
            "vp8" -> "VP8_Main"
            "vp9" -> "VP9_Profile0_3_1"
            else -> error("Unknown video codec: $codec")
        }
        return requireNotNull(VideoCodecProfileLevel.entries.firstOrNull {
            it.rawValue == rawValue && it.mime == mimeTypes[codec]
        }) { "Unsupported profile for $codec: $rawValue" }
    }
}
