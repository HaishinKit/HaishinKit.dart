import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit_example/preference.dart';

void main() {
  test('preserves WHIP and WHEP endpoint paths and query parameters', () {
    for (final endpoint in [
      'https://example.com/whip?token=test',
      'http://example.com/whep?channel=camera',
    ]) {
      final preference = Preference()..url = endpoint;
      expect(preference.makeUrl(), endpoint);
    }
  });
  test('preserves the complete SRT endpoint', () {
    const endpoint = 'srt://example.com:9000?streamid=live';
    final preference = Preference()
      ..url = endpoint
      ..streamName = 'rtmp-stream';

    expect(preference.makeUrl(), endpoint);
  });

  test('appends the stream name to the RTMP URL', () {
    final preference = Preference()
      ..url = 'rtmp://example.com/live'
      ..streamName = 'camera';

    expect(preference.makeUrl(), 'rtmp://example.com/live/camera');
  });
}
