import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_media_mixer.dart';

/// The HaishinKit MediaMixer platform interface
abstract class MediaMixerPlatformInterface extends PlatformInterface {
  MediaMixerPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static MediaMixerPlatformInterface _instance = MethodChannelMediaMixer();

  static MediaMixerPlatformInterface get instance => _instance;

  /// Sets the [MediaMixerPlatformInterface.instance]
  static set instance(MediaMixerPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Sets the frameRate property.
  Future<void> setFrameRate(Map<String, dynamic> params) {
    throw UnimplementedError('setFrameRate() has not been implemented.');
  }

  /// Sets the audio mixer settings property.
  Future<void> setAudioMixerSettings(Map<String, dynamic> params) {
    throw UnimplementedError(
        'setVideoMixerSettings() has not been implemented.');
  }

  /// Sets the video mixer settings property.
  Future<void> setVideoMixerSettings(Map<String, dynamic> params) {
    throw UnimplementedError(
        'setVideoMixerSettings() has not been implemented.');
  }

  /// Sets the sessionPreset property.
  Future<void> setSessionPreset(Map<String, dynamic> params) {
    throw UnimplementedError('setSessionPreset() has not been implemented.');
  }

  /// Sets the screen properties.
  Future<void> setScreenSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setScreenSettings() has not been implemented.');
  }

  /// Attaches an audio source.
  Future<void> attachAudio(Map<String, dynamic> params) {
    throw UnimplementedError('attachAudio() has not been implemented.');
  }

  /// Attaches a video source.
  Future<void> attachVideo(Map<String, dynamic> params) {
    throw UnimplementedError('attachVideo() has not been implemented.');
  }

  /// Starts running.
  Future<void> startRunning(Map<String, dynamic> params) {
    throw UnimplementedError('startRunning() has not been implemented.');
  }

  /// Stops running.
  Future<void> stopRunning(Map<String, dynamic> params) {
    throw UnimplementedError('stopRunning() has not been implemented.');
  }

  /// Disposes the MediaMixer platform instance.
  Future<void> dispose(Map<String, dynamic> params) {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
