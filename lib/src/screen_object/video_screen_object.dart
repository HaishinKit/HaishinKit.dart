import 'screen_object.dart';

class _Keys {
  static const track = 'track';
}

/// An object that manages offscreen rendering a video source.
final class VideoScreenObject extends ScreenObject {
  @override
  final String type = "video";

  int _track = 0;

  /// Gets the track.
  int get track => _track;

  /// Sets the track.
  set track(int value) {
    if (_track == value) return;
    _track = value;
    invalidateLayout();
  }

  @override
  Map<String, String> get elements {
    return {
      _Keys.track: track.toString()
    };
  }

  @override
  set elements(Map<String, String> value) {
    _track = int.tryParse(value[_Keys.track] ?? "0") ?? 0;
    invalidateLayout();
  }
}
