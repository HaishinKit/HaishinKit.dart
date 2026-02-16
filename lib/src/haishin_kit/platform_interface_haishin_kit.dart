import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/src/media_mixer/media_mixer_options.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../media_mixer/media_mixer_options.dart';
import 'method_channel_haishin_kit.dart';

/// The HaishinKit platform interface.
abstract class HaishinKitPlatformInterface extends PlatformInterface {
  /// Creates an instance.
  HaishinKitPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static HaishinKitPlatformInterface _instance = MethodChannelHaishinKit();

  static HaishinKitPlatformInterface get instance => _instance;

  /// Sets the [HaishinKitPlatformInterface.instance]
  static set instance(HaishinKitPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Creates a new Session platform instance.
  Future<int?> newSession(String url, StreamSessionMode mode) {
    throw UnimplementedError('newSession() has not been implemented.');
  }

  /// Creates a new MediaMixer platform instance.
  Future<int?> newMediaMixer(MediaMixerOptions options) {
    throw UnimplementedError('newMediaMixer() has not been implemented.');
  }

  Future<int?> newScreen(int? mixer) {
    throw UnimplementedError("newScreen() has not been implemented.");
  }

  /// Gets the HaishinKit library version.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Gets the available video sources.
  Future<List<VideoSource>> get videoSources {
    throw UnimplementedError('videoSources has not been implemented.');
  }
}
