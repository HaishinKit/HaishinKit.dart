import 'package:flutter/services.dart';

import '../haishin_kit/platform_interface_haishin_kit.dart';
import 'audio_codec_settings.dart';
import 'platform_interface_stream_session.dart';
import 'stream_session_exception.dart';
import 'stream_session_mode.dart';
import 'stream_session_ready_state.dart';
import 'video_codec_settings.dart';

final class StreamSession {
  static Future<StreamSession> create(
      String url, StreamSessionMode mode) async {
    var object = StreamSession._();
    object._memory =
        await HaishinKitPlatformInterface.instance.newSession(url, mode);
    object._channel =
        EventChannel("com.haishinkit.eventchannel/${object._memory}");
    return object;
  }

  int? _memory;
  late EventChannel _channel;
  VideoCodecSettings _videoSettings = VideoCodecSettings();
  AudioCodecSettings _audioSettings = AudioCodecSettings();

  StreamSession._();

  /// The platform memory address.
  int? get memory => _memory;

  Stream<StreamSessionReadyState> get readyState => _channel
      .receiveBroadcastStream()
      .map((value) => StreamSessionReadyState.values.byName(value));

  VideoCodecSettings get videoSettings => _videoSettings;

  /// Specifies the video codec properties.
  set videoSettings(VideoCodecSettings videoSettings) {
    assert(_memory != null);
    _videoSettings = videoSettings;
    StreamSessionPlatformInterface.instance.setVideoSettings(
        {"memory": _memory, "settings": videoSettings.toMap()});
  }

  AudioCodecSettings get audioSettings => _audioSettings;

  /// Specifies the audio codec properties.
  set audioSettings(AudioCodecSettings audioSettings) {
    assert(_memory != null);
    _audioSettings = audioSettings;
    StreamSessionPlatformInterface.instance.setAudioSettings(
        {"memory": _memory, "settings": audioSettings.toMap()});
  }

  /// Registers a texture to this session.
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await StreamSessionPlatformInterface.instance
        .registerTexture(params);
  }

  /// Unregisters a texture to this session.
  Future<void> unregisterTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await StreamSessionPlatformInterface.instance
        .unregisterTexture(params);
  }

  Future<int?> updateTextureSize(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await StreamSessionPlatformInterface.instance
        .updateTextureSize(params);
  }

  /// Creates a two-way connection to a server.
  Future<void> connect() async {
    assert(_memory != null);
    try {
      return await StreamSessionPlatformInterface.instance
          .connect({"memory": _memory});
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    }
  }

  /// Closes the session from the server.
  Future<void> close() async {
    assert(_memory != null);
    return await StreamSessionPlatformInterface.instance
        .close({"memory": _memory});
  }

  /// Disposes the session platform instance.
  Future<void> dispose() async {
    assert(_memory != null);
    return await StreamSessionPlatformInterface.instance
        .dispose({"memory": _memory});
  }
}

StreamSessionException _mapPlatformException(PlatformException e) {
  switch (e.code) {
    case 'CONNECT_FAILED':
      return StreamSessionConnectFailedException(e.message ?? 'Connect failed');
    default:
      return StreamSessionUnknownException(e.message ?? 'Unknown error');
  }
}
