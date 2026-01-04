import 'package:haishin_kit/stream_session_platform_interface.dart';

import 'method_channel_haishin_kit.dart';

/// The method channel implementation of [StreamSessionPlatformInterface]
class MethodChannelStreamSession extends StreamSessionPlatformInterface {
  @override
  Future<void> setAudioSettings(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Session#setAudioSettings", params);
  }

  @override
  Future<void> setVideoSettings(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Session#setVideoSettings", params);
  }

  @override
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<int>("Session#registerTexture", params);
  }

  @override
  Future<void> unregisterTexture(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Session#unregisterTexture", params);
  }

  @override
  Future<int?> updateTextureSize(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<int>("Session#updateTextureSize", params);
  }

  @override
  Future<void> connect(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Session#connect", params);
  }

  @override
  Future<void> close(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Session#close", params);
  }

  @override
  Future<void> dispose(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("Session#dispose", params);
  }
}
