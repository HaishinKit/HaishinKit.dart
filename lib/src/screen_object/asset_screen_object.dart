import '../haishin_kit/video_gravity.dart';
import 'screen_object.dart';
import 'screen.dart';

/// A local video file rendered by the OS decoder, without its audio track.
///
/// Use a file URI accessible to the native app. For bundled/received bytes,
/// [Screen.cacheAsset] returns a URI valid for the lifetime of that screen.
/// Reading starts when added to the screen. Removing the object stops reading.
/// Scene exports package the file; playback position is not saved.
final class AssetScreenObject extends ScreenObject {
  @override
  final String type = 'asset';
  Map<String, String> _elements = {
    'source': '',
    'looping': 'true',
    'videoGravity': 'resizeAspect',
  };

  String get source => _elements['source'] ?? '';
  set source(String value) {
    final uri = Uri.tryParse(value);
    if (uri == null || uri.scheme != 'file') {
      throw ArgumentError.value(value, 'source', 'Use a local file URI');
    }
    elements = {..._elements, 'source': value};
  }

  bool get isLooping => _elements['looping'] == 'true';
  set isLooping(bool value) => elements = {..._elements, 'looping': '$value'};

  VideoGravity get videoGravity => VideoGravity.values.firstWhere(
    (value) => value.name == _elements['videoGravity'],
    orElse: () => VideoGravity.resizeAspect,
  );
  set videoGravity(VideoGravity value) =>
      elements = {..._elements, 'videoGravity': value.name};

  @override
  Map<String, String> get elements => Map.of(_elements);
  @override
  set elements(Map<String, String> value) {
    if (value.length == _elements.length &&
        value.entries.every((entry) => _elements[entry.key] == entry.value)) {
      return;
    }
    _elements = Map.of(value);
    invalidateLayout();
  }
}
