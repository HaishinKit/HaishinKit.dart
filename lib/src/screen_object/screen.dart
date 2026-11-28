import 'dart:convert' as convert;
import 'dart:ui';
import 'dart:typed_data';

import '../haishin_kit/platform_interface_haishin_kit.dart';
import '../media_mixer/media_mixer.dart';
import 'platform_interface_screen.dart';
import 'screen_object.dart';
import 'screen_object_size.dart';
import 'screen_object_container.dart';
import 'screen_renderer.dart';
import 'screen_object_snapshot.dart';
import 'restored_screen_object.dart';

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
  late final ScreenRenderer _renderer = _createRenderer();
  bool _restoring = false;
  bool _sceneOperation = false;

  Screen._();

  @override
  set size(ScreenObjectSize value) {
    resize(value);
  }

  /// Sends the composition size immediately and awaits native acknowledgement.
  ///
  /// Android applies accepted updates on its render thread, so this is not a
  /// frame-presentation barrier. Await updates before changing related encoder
  /// settings or disposing the screen.
  Future<void> resize(ScreenObjectSize value) {
    assert(_memory != null);
    final operation = ScreenPlatformInterface.instance.setSize({
      "memory": _memory,
      "value": convert.json.encode(value.toJson()),
    });
    super.size = value;
    return operation;
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
    if (_restoring) return;
    if (!isUpdatingLayout) layout(_renderer);
    super.invalidateLayout();
  }

  /// Exports the actual native composition, including the default camera node,
  /// as a portable `.scene` ZIP with embedded local media. Capture must be
  /// running on Android. Archives/media are limited to 32 MiB in this bridge.
  /// Connection credentials, capture devices and codec settings are not saved.
  Future<Uint8List> exportScene() async {
    if (_sceneOperation) throw StateError('A scene operation is in progress');
    _sceneOperation = true;
    try {
      return await ScreenPlatformInterface.instance.exportScene({
        'memory': _memory,
      });
    } finally {
      _sceneOperation = false;
    }
  }

  /// Replaces the composition after native validation and media preparation.
  ///
  /// Call while disconnected and await before disposing or editing the screen.
  /// Android acknowledges the ordered render-thread update, not presentation.
  /// Does not attach capture sources. Unknown nodes/resources survive export.
  /// Restored children retain their IDs as [RestoredScreenObject] instances.
  Future<void> importScene(Uint8List bytes) async {
    if (bytes.length > 32 * 1024 * 1024) {
      throw ArgumentError('Scene exceeds 32 MiB');
    }
    if (_sceneOperation) throw StateError('A scene operation is in progress');
    _sceneOperation = true;
    try {
      final json = await ScreenPlatformInterface.instance.importScene({
        'memory': _memory,
        'bytes': bytes,
      });
      final snapshot = ScreenObjectSnapshot.fromJson(convert.json.decode(json));
      final restored = snapshot.children
          .map(RestoredScreenObject.fromSnapshot)
          .toList();
      _restoring = true;
      try {
        for (final child in children.toList()) {
          super.removeChild(child);
        }
        super.size = snapshot.size;
        for (final child in restored) {
          super.addChild(child);
        }
      } finally {
        _restoring = false;
      }
    } finally {
      _sceneOperation = false;
    }
  }

  /// Copies local video bytes into screen-owned storage and returns a file URI.
  /// Storage is removed when this screen is disposed. Maximum size: 32 MiB.
  Future<String> cacheAsset(Uint8List bytes, {String extension = 'mp4'}) {
    if (bytes.length > 32 * 1024 * 1024 ||
        !RegExp(r'^[a-zA-Z0-9]{1,8}$').hasMatch(extension)) {
      throw ArgumentError('Invalid asset size or extension');
    }
    return ScreenPlatformInterface.instance.cacheAsset({
      'memory': _memory,
      'bytes': bytes,
      'extension': extension,
    });
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
