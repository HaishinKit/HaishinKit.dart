import 'media_mixer_platform_interface.dart';
import 'method_channel_haishin_kit.dart';

/// The method channel implementation of [MediaMixerPlatformInterface]
class MethodChannelMediaMixer extends MediaMixerPlatformInterface {
  @override
  Future<bool?> getHasAudio(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<bool?>("MediaMixer#getHasAudio", params);
  }

  @override
  Future<void> setHasAudio(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#setHasAudio", params);
  }

  @override
  Future<bool?> getHasVideo(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<bool?>("MediaMixer#getHasVideo", params);
  }

  @override
  Future<void> setHasVideo(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#setHasVideo", params);
  }

  @override
  Future<void> setFrameRate(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#setFrameRate", params);
  }

  @override
  Future<void> setSessionPreset(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#setSessionPreset", params);
  }

  @override
  Future<void> setScreenSettings(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#setScreenSettings", params);
  }

  @override
  Future<void> attachAudio(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#attachAudio", params);
  }

  @override
  Future<void> attachVideo(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#attachVideo", params);
  }

  @override
  Future<void> startRunning(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#startRunning", params);
  }

  @override
  Future<void> stopRunning(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#stopRunning", params);
  }

  @override
  Future<void> dispose(Map<String, dynamic> params) async {
    return await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#dispose", params);
  }
}
