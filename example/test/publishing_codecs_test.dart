import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit_example/publishing_codecs.dart';

void main() {
  test('Android protocols filter OS encoders instead of adding codecs', () {
    final encoders = VideoCodec.values;
    List<VideoCodec> available(String url) => publishingCodecs(
      url,
      encoders,
      android: true,
      range: DynamicRangeMode.sdr,
    );
    expect(available('rtmp://example.com/live/test'), encoders);
    expect(available('srt://example.com:9000'), [VideoCodec.h264, VideoCodec.hevc]);
    expect(available('https://example.com/whip'), [
      VideoCodec.h264,
      VideoCodec.vp8,
      VideoCodec.vp9,
    ]);
    expect(available('invalid'), isEmpty);
  });

  test(
    'Apple encoding excludes Android-only codecs and allows HEVC over SRT',
    () {
      expect(
        publishingCodecs(
          'srt://example.com:9000',
          VideoCodec.values,
          android: false,
          range: DynamicRangeMode.sdr,
        ),
        [VideoCodec.h264, VideoCodec.hevc],
      );
      expect(
        publishingCodecs(
          'https://example.com/whip',
          VideoCodec.values,
          android: false,
          range: DynamicRangeMode.sdr,
        ),
        [VideoCodec.h264],
      );
    },
  );

  test('HLG requires RTMP and an OS Main10 encoder', () {
    expect(
      publishingCodecs(
        'rtmps://example.com/live/test',
        VideoCodec.values,
        android: true,
        range: DynamicRangeMode.hlg,
      ),
      [VideoCodec.hevc, VideoCodec.av1],
    );
    expect(
      publishingCodecs(
        'rtmp://example.com/live/test',
        [VideoCodec.h264],
        android: true,
        range: DynamicRangeMode.hlg,
      ),
      isEmpty,
    );
    expect(
      publishingCodecs(
        'srt://example.com:9000',
        VideoCodec.values,
        android: true,
        range: DynamicRangeMode.hlg,
      ),
      isEmpty,
    );
  });
}
