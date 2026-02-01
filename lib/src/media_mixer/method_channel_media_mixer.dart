import '../haishin_kit/method_channel_haishin_kit.dart';
import 'platform_interface_media_mixer.dart';

/// The method channel implementation of [MediaMixerPlatformInterface]
class MethodChannelMediaMixer extends MediaMixerPlatformInterface {
  @override
  Future<void> setAudioMixerSettings(Map<String, dynamic> params) async {
    await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#setAudioMixerSettings", params);
  }

  @override
  Future<void> setVideoMixerSettings(Map<String, dynamic> params) async {
    await MethodChannelHaishinKit.channel
        .invokeMethod<void>("MediaMixer#setVideoMixerSettings", params);
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
