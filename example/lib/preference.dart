class Preference {
  static Preference shared = Preference();

  String url = "rtmp://192.168.1.1/live";
  String streamName = "live";

  String makeUrl() {
    if (['srt', 'http', 'https'].contains(Uri.tryParse(url)?.scheme)) {
      return url;
    }
    return "$url/$streamName";
  }
}
