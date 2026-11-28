import 'package:haishin_kit/haishin_kit.dart';

class Preference {
  static Preference shared = Preference();

  String url = "rtmp://192.168.1.1/live";
  String streamName = "live";
  VideoCodec videoCodec = VideoCodec.h264;
  DynamicRangeMode dynamicRangeMode = DynamicRangeMode.sdr;

  String makeUrl() {
    if (['srt', 'http', 'https'].contains(Uri.tryParse(url)?.scheme)) {
      return url;
    }
    return "$url/$streamName";
  }
}
