import 'dart:convert' as convert;

import 'package:haishin_kit/haishin_kit.dart';

import 'platform_interface_screen.dart';

abstract interface class ScreenRenderer {
  /// Layout calculation for a screen object.
  void layout(ScreenObject object);
}

class PlatformScreenRenderer implements ScreenRenderer {
  final int memory;

  PlatformScreenRenderer(this.memory);

  @override
  void layout(ScreenObject object) {
    if (object is Screen) return;
    ScreenPlatformInterface.instance.layout({
      "memory": memory,
      "value": convert.json.encode(object.snapshot().toJson())
    });
  }
}
