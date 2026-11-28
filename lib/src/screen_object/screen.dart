import 'dart:convert' as convert;
import 'dart:ui';

import '../haishin_kit/platform_interface_haishin_kit.dart';
import '../media_mixer/media_mixer.dart';
import 'platform_interface_screen.dart';
import 'screen_object.dart';
import 'screen_object_size.dart';
import 'screen_object_container.dart';
import 'screen_renderer.dart';

/// The root of a mixer's native video composition.
///
/// Set [size] to configure the composition dimensions. Use [addChild] to
/// place text, images, or video tracks in the composition.
class Screen extends ScreenObjectContainer {
  /// Creates a screen associated with [mixer].
  static Future<Screen> create(MediaMixer mixer) async {
    var object = Screen._();
    object._memory = await HaishinKitPlatformInterface.instance.newScreen(
      mixer.memory,
    );
    return object;
  }

  int? _memory;
  Future<void> _pendingResize = Future.value();
  late final ScreenRenderer _renderer = _createRenderer();

  Screen._();

  @override
  set size(ScreenObjectSize value) {
    resize(value);
  }

  /// Updates the composition size and waits for the native screen to apply it.
  Future<void> resize(ScreenObjectSize value) {
    assert(_memory != null);
    super.size = value;
    return _pendingResize = _pendingResize.catchError((Object _) {}).then((_) =>
        ScreenPlatformInterface.instance.setSize({
          "memory": _memory,
          "value": convert.json.encode(value.toJson()),
        }));
  }

  @override
  void addChild(ScreenObject child) {
    assert(_memory != null);
    ScreenPlatformInterface.instance.addChild({
      "memory": _memory,
      "value": convert.json.encode(child.snapshot().toJson()),
    });
    return super.addChild(child);
  }

  @override
  void removeChild(ScreenObject child) {
    assert(_memory != null);
    ScreenPlatformInterface.instance.removeChild({
      "memory": _memory,
      "value": child.id,
    });
    return super.removeChild(child);
  }

  @override
  void invalidateLayout() {
    if (!isUpdatingLayout) layout(_renderer);
    super.invalidateLayout();
  }

  /// Reads the latest native layout rectangles in composition pixels.
  ///
  /// Text and automatic image sizes use the native renderer's measurements.
  Future<Map<String, Rect>> getBounds() async {
    final ids = <String>[];
    void collect(ScreenObjectContainer container) {
      for (final child in container.children) {
        ids.add(child.id);
        if (child is ScreenObjectContainer) collect(child);
      }
    }

    collect(this);
    final values = await ScreenPlatformInterface.instance.getBounds({
      'memory': _memory,
      'ids': ids,
    });
    return values.map((id, value) {
      final numbers = (value as List).cast<num>();
      return MapEntry(
        id,
        Rect.fromLTRB(
          numbers[0].toDouble(),
          numbers[1].toDouble(),
          numbers[2].toDouble(),
          numbers[3].toDouble(),
        ),
      );
    });
  }

  /// Releases the native screen handle.

  Future<void> dispose() async {
    assert(_memory != null);
    await ScreenPlatformInterface.instance.dispose({"memory": _memory});
  }

  ScreenRenderer _createRenderer() {
    return PlatformScreenRenderer(_memory!);
  }
}
