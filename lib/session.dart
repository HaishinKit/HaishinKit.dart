import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/session_mode.dart';
import 'package:haishin_kit/session_platform_interface.dart';
import 'package:haishin_kit/session_ready_state.dart';
import 'package:haishin_kit/video_settings.dart';
import 'package:flutter/services.dart';

import 'audio_settings.dart';

final class Session {
  static Future<Session> create(String url, SessionMode mode) async {
    var object = Session._();
    object._memory = await HaishinKitPlatform.instance.newSession(url, mode);
    object._channel =
        EventChannel("com.haishinkit.eventchannel/${object._memory}");
    return object;
  }

  int? _memory;
  late EventChannel _channel;
  VideoSettings _videoSettings = VideoSettings();
  AudioSettings _audioSettings = AudioSettings();

  Session._();

  /// The platform memory address.
  int? get memory => _memory;

  Stream<SessionReadyState> get readyState => _channel
      .receiveBroadcastStream()
      .map((value) => SessionReadyState.values.byName(value));

  VideoSettings get videoSettings => _videoSettings;

  /// Specifies the video codec properties.
  set videoSettings(VideoSettings videoSettings) {
    assert(_memory != null);
    _videoSettings = videoSettings;
    SessionPlatform.instance.setVideoSettings(
        {"memory": _memory, "settings": videoSettings.toMap()});
  }

  AudioSettings get audioSettings => _audioSettings;

  /// Specifies the audio codec properties.
  set audioSettings(AudioSettings audioSettings) {
    assert(_memory != null);
    _audioSettings = audioSettings;
    SessionPlatform.instance.setAudioSettings(
        {"memory": _memory, "settings": audioSettings.toMap()});
  }

  /// Registers a texture to this session.
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await SessionPlatform.instance.registerTexture(params);
  }

  /// Unregisters a texture to this session.
  Future<void> unregisterTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await SessionPlatform.instance.unregisterTexture(params);
  }

  Future<int?> updateTextureSize(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await SessionPlatform.instance.updateTextureSize(params);
  }

  /// Creates a two-way connection to a server.
  Future<void> connect() async {
    assert(_memory != null);
    return await SessionPlatform.instance.connect({"memory": _memory});
  }

  /// Closes the session from the server.
  Future<void> close() async {
    assert(_memory != null);
    return await SessionPlatform.instance.close({"memory": _memory});
  }

  /// Disposes the session platform instance.
  Future<void> dispose() async {
    assert(_memory != null);
    return await SessionPlatform.instance.dispose({"memory": _memory});
  }
}
