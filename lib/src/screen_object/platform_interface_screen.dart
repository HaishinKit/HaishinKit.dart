import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_screen.dart';
import 'dart:typed_data';

abstract class ScreenPlatformInterface extends PlatformInterface {
  ScreenPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static ScreenPlatformInterface _instance = MethodChannelScreen();

  static ScreenPlatformInterface get instance => _instance;

  static set instance(ScreenPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<void> setSize(Map<String, dynamic> params) {
    throw UnimplementedError('setSize() has not been implemented.');
  }

  Future<void> addChild(Map<String, dynamic> params) {
    throw UnimplementedError('addChild() has not been implemented.');
  }

  Future<void> removeChild(Map<String, dynamic> params) {
    throw UnimplementedError('removeChild() has not been implemented.');
  }

  Future<void> layout(Map<String, dynamic> params) {
    throw UnimplementedError('layout() has not been implemented.');
  }

  Future<Map<String, dynamic>> getBounds(Map<String, dynamic> params) {
    throw UnimplementedError('getBounds() has not been implemented.');
  }

  Future<void> dispose(Map<String, dynamic> params) {
    throw UnimplementedError('dispose() has not been implemented.');
  }

  Future<Uint8List> exportScene(Map<String, dynamic> params) =>
      throw UnimplementedError('exportScene() has not been implemented.');

  Future<String> importScene(Map<String, dynamic> params) =>
      throw UnimplementedError('importScene() has not been implemented.');

  Future<String> cacheAsset(Map<String, dynamic> params) =>
      throw UnimplementedError('cacheAsset() has not been implemented.');
}
