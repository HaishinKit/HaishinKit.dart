import 'package:haishin_kit/session_mode.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'haishin_kit_method_channel.dart';

/// The HaishinKit platform interface.
abstract class HaishinKitPlatform extends PlatformInterface {
  /// Creates an instance.
  HaishinKitPlatform() : super(token: _token);

  static final Object _token = Object();

  static HaishinKitPlatform _instance = MethodChannelHaishinKit();

  static HaishinKitPlatform get instance => _instance;

  /// Sets the [HaishinKitPlatform.instance]
  static set instance(HaishinKitPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Creates a new Session platform instance.
  Future<int?> newSession(String url, SessionMode mode) {
    throw UnimplementedError('newSession() has not been implemented.');
  }

  /// Creates a new MediaMixer platform instance.
  Future<int?> newMediaMixer() {
    throw UnimplementedError('newMediaMixer() has not been implemented.');
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
