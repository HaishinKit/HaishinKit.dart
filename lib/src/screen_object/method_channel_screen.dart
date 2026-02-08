import '../haishin_kit/method_channel_haishin_kit.dart';
import 'platform_interface_screen.dart';

class MethodChannelScreen extends ScreenPlatformInterface {
  @override
  Future<void> addChild(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Screen#addChild", params);
  }

  @override
  Future<void> removeChild(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Screen#removeChild", params);
  }

  @override
  Future<void> layout(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Screen#layout", params);
  }

  @override
  Future<void> dispose(Map<String, dynamic> params) async {
  return await MethodChannelHaishinKit.channel
      .invokeMethod<void>("Screen#dispose", params);
  }
}
