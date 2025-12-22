import 'package:haishin_kit/session_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The HaishinKit Session platform interface
abstract class SessionPlatform extends PlatformInterface {
  SessionPlatform() : super(token: _token);

  static final Object _token = Object();

  static SessionPlatform _instance = MethodChannelSession();

  static SessionPlatform get instance => _instance;

  /// Sets the [SessionPlatform.instance]
  static set instance(SessionPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Sets the audio codec settings.
  Future<void> setAudioSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setAudioSettings() has not been implemented.');
  }

  /// Sets the video codec properties.
  Future<void> setVideoSettings(Map<String, dynamic> params) {
    throw UnimplementedError('setVideoSettings() has not been implemented.');
  }

  /// Register a texture with FlutterTexture.
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    throw UnimplementedError('registerTexture() has not been implemented.');
  }

  /// Unregister a texture with FlutterTexture.
  Future<void> unregisterTexture(Map<String, dynamic> params) async {
    throw UnimplementedError('unregisterTexture() has not been implemented.');
  }

  Future<int?> updateTextureSize(Map<String, dynamic> params) async {
    throw UnimplementedError('updateTextureSize() has not been implemented.');
  }

  /// Connects the session.
  Future<void> connect(Map<String, dynamic> params) {
    throw UnimplementedError('connect() has not been implemented.');
  }

  /// Closes the session.
  Future<void> close(Map<String, dynamic> params) {
    throw UnimplementedError('close() has not been implemented.');
  }

  /// Disposes the Session platform instance.
  Future<void> dispose(Map<String, dynamic> params) {
    throw UnimplementedError('dispose() has not been implemented.');
  }
}
