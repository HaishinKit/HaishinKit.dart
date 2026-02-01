import 'dart:convert' as convert;

import 'package:haishin_kit/haishin_kit.dart';

import 'platform_interface_screen.dart';

class Screen extends ScreenObjectContainer {
  static Future<Screen> create(MediaMixer mixer) async {
    var object = Screen._();
    object._memory =
        await HaishinKitPlatformInterface.instance.newScreen(mixer.memory);
    return object;
  }

  int? _memory;

  Screen._();

  @override
  Future<void> addChild(ScreenObject child) async {
    assert(_memory != null);

    ScreenPlatformInterface.instance.addChild({
      "memory": _memory,
      "value": convert.json.encode(child.snapshot().toJson())
    });
    return super.addChild(child);
  }

  @override
  Future<void> removeChild(ScreenObject child) async {
    assert(_memory != null);
    ScreenPlatformInterface.instance.removeChild({
      "memory": _memory,
      "value": child.id,
    });
    return super.addChild(child);
  }

  Future<void> update(ScreenObject object) async {
    assert(_memory != null);
    return ScreenPlatformInterface.instance.update({
      "memory": _memory,
      "value": convert.json.encode(object.snapshot().toJson())
    });
  }
}
