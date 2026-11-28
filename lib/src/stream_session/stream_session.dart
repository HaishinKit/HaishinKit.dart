import 'package:flutter/services.dart';

import '../haishin_kit/platform_interface_haishin_kit.dart';
import 'audio_codec_settings.dart';
import '../media_mixer/dynamic_range_mode.dart';
import 'platform_interface_stream_session.dart';
import 'stream_session_exception.dart';
import 'stream_session_mode.dart';
import 'stream_session_ready_state.dart';
import 'video_codec_settings.dart';

/// A native streaming session for publishing or playback.
///
/// Create a session with [create], observe [readyState], and call [connect].
/// Call [close] to disconnect and [dispose] when the session is no longer needed.
final class StreamSession {
  /// Creates a native session for [url] in the specified [mode].
  ///
  /// For RTMP, include the stream name in [url], as in
  /// `rtmp://example.com/live/camera`. For SRT, pass the complete
  /// `srt://` URL with any query options required by the server.
  /// Call [connect] when ready to start publishing or playback.
  static Future<StreamSession> create(
    String url,
    StreamSessionMode mode, {
    DynamicRangeMode dynamicRangeMode = DynamicRangeMode.sdr,
  }) async {
    var object = StreamSession._();
    object._memory = await HaishinKitPlatformInterface.instance
        .newSessionWithOptions(url, mode, dynamicRangeMode);
    object._dynamicRangeMode = dynamicRangeMode;
    object._channel = EventChannel(
      "com.haishinkit.eventchannel/${object._memory}",
    );
    return object;
  }

  int? _memory;
  DynamicRangeMode _dynamicRangeMode = DynamicRangeMode.sdr;

  /// The range selected before native session creation.
  DynamicRangeMode get dynamicRangeMode => _dynamicRangeMode;
  late EventChannel _channel;
  VideoCodecSettings _videoSettings = VideoCodecSettings();
  AudioCodecSettings _audioSettings = AudioCodecSettings();

  StreamSession._();

  /// The handle used to identify this session on the native platform.
  int? get memory => _memory;

  /// Connection state changes reported by the native session.
  Stream<StreamSessionReadyState> get readyState => _channel
      .receiveBroadcastStream()
      .map((value) => StreamSessionReadyState.values.byName(value));

  /// Locally cached video encoding settings.
  VideoCodecSettings get videoSettings => _videoSettings;

  /// Applies video encoding settings to the native session.
  set videoSettings(VideoCodecSettings videoSettings) {
    assert(_memory != null);
    setVideoSettings(videoSettings);
  }

  /// Applies [settings] and waits for the native encoder configuration.
  ///
  /// Use this before [connect] when output dimensions must be set before startup.
  /// Change dimensions only while the session is closed.
  Future<void> setVideoSettings(VideoCodecSettings settings) async {
    assert(_memory != null);
    _videoSettings = settings;
    await StreamSessionPlatformInterface.instance.setVideoSettings({
      "memory": _memory,
      "settings": settings.toMap(),
    });
  }

  /// Changes only the encoded dimensions, preserving native bitrate and profile.
  ///
  /// Await this before [connect]. Change dimensions only while closed. The
  /// cached [videoSettings] dimensions are updated immediately.
  Future<void> setVideoSize({required int width, required int height}) async {
    assert(_memory != null);
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Video dimensions must be positive.');
    }
    _videoSettings = _videoSettings.copyWith(width: width, height: height);
    await StreamSessionPlatformInterface.instance.setVideoSettings({
      'memory': _memory,
      'settings': {'width': width, 'height': height},
    });
  }

  /// Selects an OS video encoder without changing native bitrate or dimensions.
  ///
  /// Select before connecting. HLG publishing requires [VideoCodec.hevc] or,
  /// on supported Android devices, [VideoCodec.av1]. Server support is required.
  Future<void> setVideoCodec(VideoCodec codec) async {
    assert(_memory != null);
    _videoSettings = _videoSettings.copyWith(codec: codec);
    await StreamSessionPlatformInterface.instance.setVideoSettings({
      'memory': _memory,
      'settings': {'codec': codec.name},
    });
  }

  /// The current audio encoding settings.
  AudioCodecSettings get audioSettings => _audioSettings;

  /// Applies audio encoding settings to the native session.
  set audioSettings(AudioCodecSettings audioSettings) {
    assert(_memory != null);
    _audioSettings = audioSettings;
    StreamSessionPlatformInterface.instance.setAudioSettings({
      "memory": _memory,
      "settings": audioSettings.toMap(),
    });
  }

  /// Registers a Flutter texture for this session and returns its ID.
  Future<int?> registerTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await StreamSessionPlatformInterface.instance.registerTexture(
      params,
    );
  }

  /// Unregisters the Flutter texture for this session.
  Future<void> unregisterTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await StreamSessionPlatformInterface.instance.unregisterTexture(
      params,
    );
  }

  /// Updates the native texture configuration.
  Future<int?> updateTexture(Map<String, dynamic> params) async {
    assert(_memory != null);
    params["memory"] = _memory;
    return await StreamSessionPlatformInterface.instance.updateTexture(params);
  }

  /// Connects to the endpoint to publish or play the stream.
  Future<void> connect() async {
    assert(_memory != null);
    try {
      return await StreamSessionPlatformInterface.instance.connect({
        "memory": _memory,
      });
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    }
  }

  /// Disconnects the session from its endpoint.
  Future<void> close() async {
    assert(_memory != null);
    return await StreamSessionPlatformInterface.instance.close({
      "memory": _memory,
    });
  }

  /// Releases the native session resources.
  Future<void> dispose() async {
    assert(_memory != null);
    return await StreamSessionPlatformInterface.instance.dispose({
      "memory": _memory,
    });
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
