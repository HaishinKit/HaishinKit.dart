import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_screen.dart';

abstract class ScreenPlatformInterface extends PlatformInterface {
  ScreenPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static ScreenPlatformInterface _instance = MethodChannelScreen();

  static ScreenPlatformInterface get instance => _instance;

  static set instance(ScreenPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> addChild(Map<String, dynamic> params) {
    throw UnimplementedError('addChild() has not been implemented.');
  }

  Future<void> removeChild(Map<String, dynamic> params) {
    throw UnimplementedError('removeChild() has not been implemented.');
  }

  Future<void> update(Map<String, dynamic> params) {
    throw UnimplementedError('update() has not been implemented.');
  }
}
