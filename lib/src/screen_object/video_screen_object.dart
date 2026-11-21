import 'screen_object.dart';

class _Keys {
  static const track = 'track';
}

/// Displays a video track on the composition screen.
final class VideoScreenObject extends ScreenObject {
  @override
  final String type = "video";

  int _track = 0;

  /// The mixer video track to display. Defaults to track 0.
  int get track => _track;

  /// Changes the displayed track and invalidates layout.
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
