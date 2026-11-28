/// The capture, composition, and display range selected before creating a session.
///
/// HLG requires a compatible camera/codec and native HDR preview. Use RTMP(S)
/// with HEVC Main10 (or an OS AV1 encoder on Android) for HDR publishing.
enum DynamicRangeMode { sdr, hlg }
