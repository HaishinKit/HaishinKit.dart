import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/session_mode.dart';
import 'package:haishin_kit/session_platform_interface.dart';
import 'package:haishin_kit/video_settings.dart';

import 'audio_settings.dart';

class Session {
  static Future<Session> create(String url, SessionMode mode) async {
    var object = Session._();
    object._memory = await HaishinKitPlatform.instance.newSession(url, mode);
    return object;
  }

  int? _memory;
  VideoSettings _videoSettings = VideoSettings();
  AudioSettings _audioSettings = AudioSettings();

  Session._();

  int? get memory => _memory;

  VideoSettings get videoSettings => _videoSettings;

  set videoSettings(VideoSettings videoSettings) {
    assert(_memory != null);
    _videoSettings = videoSettings;
    SessionPlatform.instance.setVideoSettings(
        {"memory": _memory, "settings": videoSettings.toMap()});
  }

  AudioSettings get audioSettings => _audioSettings;

  set audioSettings(AudioSettings audioSettings) {
    assert(_memory != null);
    _audioSettings = audioSettings;
    SessionPlatform.instance.setAudioSettings(
        {"memory": _memory, "settings": audioSettings.toMap()});
  }

  Future<int?> registerTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return SessionPlatform.instance.registerTexture(params);
  }

  Future<void> unregisterTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return SessionPlatform.instance.unregisterTexture(params);
  }

  Future<int?> updateTextureSize(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return SessionPlatform.instance.updateTextureSize(params);
  }

  Future<void> connect() async {
    assert(_memory != null);
    return SessionPlatform.instance.close({"memory": _memory});
  }

  Future<void> close() async {
    assert(_memory != null);
    SessionPlatform.instance.close({"memory": _memory});
  }

  Future<void> dispose() async {
    assert(_memory != null);
    SessionPlatform.instance.dispose({"memory": _memory});
  }
}
