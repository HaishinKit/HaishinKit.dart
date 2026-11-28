import '../haishin_kit/method_channel_haishin_kit.dart';
import 'platform_interface_screen.dart';
import 'dart:typed_data';

class MethodChannelScreen extends ScreenPlatformInterface {
  @override
  Future<Uint8List> exportScene(Map<String, dynamic> params) async =>
      (await MethodChannelHaishinKit.channel.invokeMethod<Uint8List>(
        'Screen#exportScene',
        params,
      ))!;

  @override
  Future<String> importScene(Map<String, dynamic> params) async =>
      (await MethodChannelHaishinKit.channel.invokeMethod<String>(
        'Screen#importScene',
        params,
      ))!;

  @override
  Future<String> cacheAsset(Map<String, dynamic> params) async =>
      (await MethodChannelHaishinKit.channel.invokeMethod<String>(
        'Screen#cacheAsset',
        params,
      ))!;
  @override
  Future<void> setSize(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel.invokeMethod<void>(
      "Screen#setSize",
      params,
    );
  }

  @override
  Future<void> addChild(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel.invokeMethod<void>(
      "Screen#addChild",
      params,
    );
  }

  @override
  Future<void> removeChild(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel.invokeMethod<void>(
      "Screen#removeChild",
      params,
    );
  }

  @override
  Future<void> layout(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel.invokeMethod<void>(
      "Screen#layout",
      params,
    );
  }

  @override
  Future<Map<String, dynamic>> getBounds(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
            .invokeMapMethod<String, dynamic>('Screen#getBounds', params) ??
        {};
  }

  @override
  Future<void> dispose(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel.invokeMethod<void>(
      "Screen#dispose",
      params,
    );
  }
}
