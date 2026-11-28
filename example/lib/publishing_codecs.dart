import 'package:haishin_kit/haishin_kit.dart';

/// Protocol support is narrower than the OS encoder catalog.
List<VideoCodec> publishingCodecs(
  String url,
  List<VideoCodec> encoders, {
  required bool android,
  required DynamicRangeMode range,
}) {
  final scheme = Uri.tryParse(url.trim())?.scheme.toLowerCase();
  final allowed = switch (scheme) {
    'rtmp' ||
    'rtmps' => android ? VideoCodec.values : [VideoCodec.h264, VideoCodec.hevc],
    'srt' => [VideoCodec.h264, VideoCodec.hevc],
    'http' || 'https' =>
      android
          ? [VideoCodec.h264, VideoCodec.vp8, VideoCodec.vp9]
          : [VideoCodec.h264],
    _ => <VideoCodec>[],
  };
  if (range == DynamicRangeMode.hlg &&
      !const ['rtmp', 'rtmps'].contains(scheme)) {
    return [];
  }
  return encoders
      .where(
        (codec) =>
            allowed.contains(codec) &&
            (range == DynamicRangeMode.sdr ||
                const [VideoCodec.hevc, VideoCodec.av1].contains(codec)),
      )
      .toList();
}

String videoCodecLabel(VideoCodec codec) => switch (codec) {
  VideoCodec.h264 => 'H.264',
  VideoCodec.hevc => 'HEVC (H.265)',
  VideoCodec.av1 => 'AV1',
  VideoCodec.vp8 => 'VP8',
  VideoCodec.vp9 => 'VP9',
};
