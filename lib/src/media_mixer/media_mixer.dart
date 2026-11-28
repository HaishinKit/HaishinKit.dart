import 'dart:convert' as convert;

import 'package:flutter/services.dart';
import 'package:haishin_kit/haishin_kit.dart';

import '../stream_session/av_capture_session_preset.dart';
import 'platform_interface_media_mixer.dart';

/// Captures and mixes audio and video for native streaming sessions.
///
/// Attach sources with [attachAudio] and [attachVideo], add overlays to [screen],
/// and call [startRunning] to start capture. Release native resources with
/// [dispose] when the mixer is no longer needed.
class MediaMixer {
  /// Creates a native mixer and its composition screen.
  ///
  /// [options] selects the composition range and Apple capture session behavior.
  static Future<MediaMixer> create({
    MediaMixerOptions options = const MediaMixerOptions(),
  }) async {
    final object = MediaMixer._();
    object._memory = await HaishinKitPlatformInterface.instance.newMediaMixer(
      options,
    );
    object._screen = await Screen.create(object);
    return object;
  }

  int? _memory;

  /// The handle used to identify this mixer on the native platform.
  int? get memory => _memory;

  int _frameRate = 30;

  /// The requested video frame rate in frames per second.
  int get frameRate => _frameRate;

  /// Requests a video frame rate in frames per second.
  set frameRate(int frameRate) {
    assert(_memory != null);
    _frameRate = frameRate;
    MediaMixerPlatformInterface.instance.setFrameRate({
      "memory": _memory,
      "value": frameRate,
    });
  }

  AVCaptureSessionPreset _sessionPreset = AVCaptureSessionPreset.hd1280x720;

  /// The requested capture session preset.
  AVCaptureSessionPreset get sessionPreset => _sessionPreset;

  /// Sets the capture session preset on supported Apple platforms.
  set sessionPreset(AVCaptureSessionPreset sessionPreset) {
    assert(_memory != null);
    _sessionPreset = sessionPreset;
    MediaMixerPlatformInterface.instance.setSessionPreset({
      "memory": _memory,
      "value": sessionPreset.presetName,
    });
  }

  VideoMixerSettings _videoMixerSettings = VideoMixerSettings();

  /// The current video mixing settings.
  VideoMixerSettings get videoMixerSettings => _videoMixerSettings;

  /// Sets the video mixer settings.
  set videoMixerSettings(VideoMixerSettings videoMixerSettings) {
    assert(_memory != null);
    _videoMixerSettings = videoMixerSettings;
    MediaMixerPlatformInterface.instance.setVideoMixerSettings({
      "memory": _memory,
      "value": convert.json.encode(videoMixerSettings.toJson()),
    });
  }

  AudioMixerSettings _audioMixerSettings = AudioMixerSettings();

  /// The current audio mixing settings.
  AudioMixerSettings get audioMixerSettings => _audioMixerSettings;

  /// Sets the audio mixer settings.
  set audioMixerSettings(AudioMixerSettings audioMixerSettings) {
    assert(_memory != null);
    _audioMixerSettings = audioMixerSettings;
    MediaMixerPlatformInterface.instance.setAudioMixerSettings({
      "memory": _memory,
      "value": convert.json.encode(audioMixerSettings.toJson()),
    });
  }

  Screen? _screen;

  /// The native composition screen associated with this mixer.
  Screen? get screen => _screen;

  MediaMixer._();

  /// Attaches the default audio input. Pass `null` to detach it.
  ///
  /// The built-in platform implementations use the default audio track.
  Future<void> attachAudio(int track, AudioSource? audio) async {
    assert(_memory != null);
    try {
      await MediaMixerPlatformInterface.instance.attachAudio({
        "memory": _memory,
        "source": audio?.toMap(),
        "track": track,
      });
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    }
  }

  /// Attaches [video] to [track]. Pass `null` to detach that track.
  Future<void> attachVideo(int track, VideoSource? video) async {
    assert(_memory != null);
    try {
      await MediaMixerPlatformInterface.instance.attachVideo({
        "memory": _memory,
        "track": track,
        "value": video != null ? convert.json.encode(video.toJson()) : null,
      });
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    }
  }

  /// Starts audio and video capture and screen composition.
  Future<void> startRunning() async {
    assert(_memory != null);
    await MediaMixerPlatformInterface.instance.startRunning({
      "memory": _memory,
    });
  }

  /// Stops capture while retaining the mixer for reuse.
  Future<void> stopRunning() async {
    assert(_memory != null);
    await MediaMixerPlatformInterface.instance.stopRunning({"memory": _memory});
  }

  /// Releases the native mixer and its composition screen.
  Future<void> dispose() async {
    assert(_memory != null);
    await screen?.dispose();
    await MediaMixerPlatformInterface.instance.dispose({"memory": _memory});
  }
}

MediaMixerException _mapPlatformException(PlatformException e) {
  switch (e.code) {
    case "FAILED_TO_ATTACH":
      return MediaMixerFailedToAttachException(e.message ?? "Unknown error");
    default:
      return MediaMixerUnknownException(e.message ?? 'Unknown error');
  }
}
