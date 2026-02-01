import 'dart:convert' as convert;

import 'package:flutter/services.dart';

import 'audio_mixer_settings.dart';
import 'audio_source.dart';
import 'av_capture_session_preset.dart';
import 'media_mixer_exception.dart';
import 'platform_interface_haishin_kit.dart';
import 'platform_interface_media_mixer.dart';
import 'screen_settings.dart';
import 'video_mixer_settings.dart';
import 'video_source.dart';

class MediaMixer {
  static Future<MediaMixer> create() async {
    var object = MediaMixer._();
    object._memory = await HaishinKitPlatformInterface.instance.newMediaMixer();
    return object;
  }

  int? _memory;

  /// The platform memory address.
  int? get memory => _memory;

  int _frameRate = 30;

  /// Gets the frameRate.
  int get frameRate => _frameRate;

  /// Sets the frameRate.
  set frameRate(int frameRate) {
    assert(_memory != null);
    _frameRate = frameRate;
    MediaMixerPlatformInterface.instance
        .setFrameRate({"memory": _memory, "value": frameRate});
  }

  AVCaptureSessionPreset _sessionPreset = AVCaptureSessionPreset.hd1280x720;

  /// Gets the sessionPreset.
  AVCaptureSessionPreset get sessionPreset => _sessionPreset;

  /// Sets the sessionPreset for iOS.
  set sessionPreset(AVCaptureSessionPreset sessionPreset) {
    assert(_memory != null);
    _sessionPreset = sessionPreset;
    MediaMixerPlatformInterface.instance.setSessionPreset(
        {"memory": _memory, "value": sessionPreset.presetName});
  }

  ScreenSettings _screenSettings = ScreenSettings();

  /// Gets the screen properties.
  ScreenSettings get screenSettings => _screenSettings;

  /// Sets the screen properties.
  set screenSettings(ScreenSettings screenSettings) {
    assert(_memory != null);
    _screenSettings = screenSettings;
    MediaMixerPlatformInterface.instance.setScreenSettings(
        {"memory": _memory, "settings": screenSettings.toMap()});
  }

  VideoMixerSettings _videoMixerSettings = VideoMixerSettings();

  /// Gets the video mixer settings.
  VideoMixerSettings get videoMixerSettings => _videoMixerSettings;

  /// Sets the video mixer settings.
  set videoMixerSettings(VideoMixerSettings videoMixerSettings) {
    assert(_memory != null);
    _videoMixerSettings = videoMixerSettings;
    MediaMixerPlatformInterface.instance.setVideoMixerSettings({
      "memory": _memory,
      "value": convert.json.encode(videoMixerSettings.toJson())
    });
  }

  AudioMixerSettings _audioMixerSettings = AudioMixerSettings();

  /// Gets the audio mixer settings.
  AudioMixerSettings get audioMixerSettings => _audioMixerSettings;

  /// Sets the audio mixer settings.
  set audioMixerSettings(AudioMixerSettings audioMixerSettings) {
    assert(_memory != null);
    _audioMixerSettings = audioMixerSettings;
    MediaMixerPlatformInterface.instance.setAudioMixerSettings({
      "memory": _memory,
      "value": convert.json.encode(audioMixerSettings.toJson())
    });
  }

  MediaMixer._();

  /// Attaches an AudioSource to this mixer.
  Future<void> attachAudio(int track, AudioSource? audio) async {
    assert(_memory != null);
    try {
      await MediaMixerPlatformInterface.instance.attachAudio(
          {"memory": _memory, "source": audio?.toMap(), "track": track});
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    }
  }

  /// Attaches a VideoSource to this mixer.
  Future<void> attachVideo(int track, VideoSource? video) async {
    assert(_memory != null);
    try {
      await MediaMixerPlatformInterface.instance.attachVideo({
        "memory": _memory,
        "track": track,
        "value": video != null ? convert.json.encode(video.toJson()) : null
      });
    } on PlatformException catch (e) {
      throw _mapPlatformException(e);
    }
  }

  Future<void> startRunning() async {
    assert(_memory != null);
    await MediaMixerPlatformInterface.instance
        .startRunning({"memory": _memory});
  }

  Future<void> stopRunning() async {
    assert(_memory != null);
    await MediaMixerPlatformInterface.instance.stopRunning({"memory": _memory});
  }

  /// Disposes this mixer platform instance.
  Future<void> dispose() async {
    assert(_memory != null);
    await MediaMixerPlatformInterface.instance.dispose({"memory": _memory});
  }
}

MediaMixerException _mapPlatformException(PlatformException e) {
  switch (e.code) {
    default:
      return MediaMixerUnknownException(e.message ?? 'Unknown error');
  }
}
