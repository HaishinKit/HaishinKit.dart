import 'dart:convert' as convert;

import '../haishin_kit/platform_interface_haishin_kit.dart';
import '../media_mixer/media_mixer.dart';
import 'platform_interface_screen.dart';
import 'screen_object.dart';
import 'screen_object_container.dart';
import 'screen_renderer.dart';

class Screen extends ScreenObjectContainer {
  static Future<Screen> create(MediaMixer mixer) async {
    var object = Screen._();
    object._memory =
        await HaishinKitPlatformInterface.instance.newScreen(mixer.memory);
    return object;
  }

  int? _memory;
  late final ScreenRenderer _renderer = _createRenderer();

  Screen._();

  @override
  void addChild(ScreenObject child) {
    assert(_memory != null);
    ScreenPlatformInterface.instance.addChild({
      "memory": _memory,
      "value": convert.json.encode(child.snapshot().toJson())
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
    layout(_renderer);
    super.invalidateLayout();
  }

  Future<void> dispose() async {
    assert(_memory != null);
    await ScreenPlatformInterface.instance.dispose({"memory": _memory});
  }

  ScreenRenderer _createRenderer() {
    return PlatformScreenRenderer(_memory!);
  }
}
