import 'package:haishin_kit/haishin_kit.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'method_channel_haishin_kit.dart';

/// The contract that native implementations of HaishinKit must implement.
abstract class HaishinKitPlatformInterface extends PlatformInterface {
  /// Creates a platform implementation with a verification token.
  HaishinKitPlatformInterface() : super(token: _token);

  static final Object _token = Object();

  static HaishinKitPlatformInterface _instance = MethodChannelHaishinKit();

  /// The platform implementation used by the plugin.
  static HaishinKitPlatformInterface get instance => _instance;

  /// Registers a platform implementation.
  static set instance(HaishinKitPlatformInterface instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Creates a native streaming session and returns its handle.
  Future<int?> newSession(String url, StreamSessionMode mode) {
    throw UnimplementedError('newSession() has not been implemented.');
  }

  /// Creates a native media mixer and returns its handle.
  Future<int?> newMediaMixer(MediaMixerOptions options) {
    throw UnimplementedError('newMediaMixer() has not been implemented.');
  }

  /// Returns a handle to the composition screen for the native [mixer].
  Future<int?> newScreen(int? mixer) {
    throw UnimplementedError("newScreen() has not been implemented.");
  }

  /// Returns the native HaishinKit library identifier.
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('getPlatformVersion() has not been implemented.');
  }

  /// Lists the video input sources reported by the native platform.
  Future<List<VideoSource>> get videoSources {
    throw UnimplementedError('videoSources has not been implemented.');
  }
}
