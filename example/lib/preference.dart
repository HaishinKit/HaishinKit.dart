class Preference {
  static Preference shared = Preference();

  String url = "rtmp://192.168.1.11/live";
  String streamName = "live";

  String makeUrl() {
    return "$url/$streamName";
  }
}
