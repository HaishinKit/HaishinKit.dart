import 'screen_object.dart';

class _Keys {
  static const track = 'track';
  static const imageOrientation = 'imageOrientation';
  static const deviceOrientation = 'deviceOrientation';
  static const rotatesWithContent = 'rotatesWithContent';
}

/// The orientation of a source image.
///
/// Mirrors `com.haishinkit.graphics.ImageOrientation` on Android.
enum ImageOrientation { up, down, left, right }

/// An object that manages offscreen rendering a video source.
final class VideoScreenObject extends ScreenObject {
  @override
  final String type = "video";

  int _track = 0;
  ImageOrientation _imageOrientation = ImageOrientation.up;
  int _deviceOrientation = 0;
  bool _rotatesWithContent = true;

  /// Gets the track.
  int get track => _track;

  /// Gets the orientation of the source image.
  ImageOrientation get imageOrientation => _imageOrientation;

  /// Sets the orientation of the source image.
  set imageOrientation(ImageOrientation value) {
    if (_imageOrientation == value) return;
    _imageOrientation = value;
    invalidateLayout();
  }

  /// Gets the device orientation.
  int get deviceOrientation => _deviceOrientation;

  /// Sets the device orientation, as an `android.view.Surface.ROTATION_*`
  /// value (0, 1, 2, 3).
  ///
  /// Without this the capture keeps the rotation it had when the video source
  /// was attached, so a device held in landscape renders rotated by 90
  /// degrees.
  set deviceOrientation(int value) {
    if (_deviceOrientation == value) return;
    _deviceOrientation = value;
    invalidateLayout();
  }

  /// Whether the video rotates to follow the device orientation.
  bool get rotatesWithContent => _rotatesWithContent;

  /// Sets whether the video rotates to follow the device orientation.
  set rotatesWithContent(bool value) {
    if (_rotatesWithContent == value) return;
    _rotatesWithContent = value;
    invalidateLayout();
  }

  /// Sets the track.
  set track(int value) {
    if (_track == value) return;
    _track = value;
    invalidateLayout();
  }

  @override
  Map<String, String> get elements {
    return {
      _Keys.track: track.toString(),
      _Keys.imageOrientation: imageOrientation.name,
      _Keys.deviceOrientation: deviceOrientation.toString(),
      _Keys.rotatesWithContent: rotatesWithContent.toString(),
    };
  }

  @override
  set elements(Map<String, String> value) {
    _track = int.tryParse(value[_Keys.track] ?? "0") ?? 0;
    _deviceOrientation =
        int.tryParse(value[_Keys.deviceOrientation] ?? "0") ?? 0;
    _rotatesWithContent =
        (value[_Keys.rotatesWithContent] ?? "true").toLowerCase() == "true";
    final orientation = value[_Keys.imageOrientation];
    if (orientation != null) {
      _imageOrientation = ImageOrientation.values.firstWhere(
        (e) => e.name == orientation,
        orElse: () => ImageOrientation.up,
      );
    }
    invalidateLayout();
  }
}
