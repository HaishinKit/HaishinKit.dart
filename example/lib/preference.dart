class Preference {
  static Preference shared = Preference();

  String url = "rtmp://192.168.1.1/live";
  String streamName = "live";

  String makeUrl() {
    if (url.toLowerCase().startsWith('srt://')) {
      return url;
    }
    return "$url/$streamName";
  }
}
