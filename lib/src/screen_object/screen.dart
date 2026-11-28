import 'dart:async';
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
  Future<void>? _pendingResize;
  Future<void>? _disposal;
  late final ScreenRenderer _renderer = _createRenderer();

  Screen._();

  @override
  set size(ScreenObjectSize value) {
    unawaited(
      resize(value).catchError((Object error, StackTrace stack) {
        Zone.current.handleUncaughtError(error, stack);
      }),
    );
  }

  /// Sends the composition size in order and awaits the native acknowledgement.
  ///
  /// The first update is sent immediately; later updates wait for earlier ones.
  /// Android applies accepted updates on its render thread, so this is not a
  /// frame-presentation barrier. Configure encoder dimensions separately before
  /// connecting with `StreamSession.setVideoSize`.
  Future<void> resize(ScreenObjectSize value) {
    if (_disposal != null) throw StateError('The screen is being disposed.');
    assert(_memory != null);
    super.size = value;
    Future<void> send() => ScreenPlatformInterface.instance.setSize({
      "memory": _memory,
      "value": convert.json.encode(value.toJson()),
    });
    final previous = _pendingResize;
    final operation = previous == null
        ? send()
        : previous.catchError((Object _) {}).then((_) => send());
    _pendingResize = operation;
    void clear() {
      if (identical(_pendingResize, operation)) _pendingResize = null;
    }

    unawaited(
      operation.then<void>(
        (_) => clear(),
        onError: (Object _, StackTrace _) => clear(),
      ),
    );
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

  /// Finishes queued resizes, then releases the native screen handle.
  Future<void> dispose() => _disposal ??= _disposeScreen();

  Future<void> _disposeScreen() async {
    assert(_memory != null);
    await _pendingResize?.catchError((Object _) {});
    await ScreenPlatformInterface.instance.dispose({"memory": _memory});
    _memory = null;
  }

  ScreenRenderer _createRenderer() {
    return PlatformScreenRenderer(_memory!);
  }
}
