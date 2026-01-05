import 'package:flutter/services.dart';

import 'haishin_kit_platform_interface.dart';
import 'media_mixer_platform_interface.dart';
import 'media_mixer_exception.dart';
import 'screen_settings.dart';
import 'video_source.dart';
import 'audio_source.dart';
import 'av_capture_session_preset.dart';

class MediaMixer {
  static Future<MediaMixer> create() async {
    var object = MediaMixer._();
    object._memory = await HaishinKitPlatformInterface.instance.newMediaMixer();
    return object;
  }

  int? _memory;
  int _frameRate = 30;
  AVCaptureSessionPreset _sessionPreset = AVCaptureSessionPreset.hd1280x720;
  ScreenSettings _screenSettings = ScreenSettings();

  MediaMixer._();

  /// The platform memory address.
  int? get memory => _memory;

  /// Gets the frameRate.
  int get frameRate => _frameRate;

  /// Sets the frameRate.
  set frameRate(int frameRate) {
    assert(_memory != null);
    _frameRate = frameRate;
    MediaMixerPlatformInterface.instance
        .setFrameRate({"memory": _memory, "value": frameRate});
  }

  /// Gets the sessionPreset.
  AVCaptureSessionPreset get sessionPreset => _sessionPreset;

  /// Sets the sessionPreset for iOS.
  set sessionPreset(AVCaptureSessionPreset sessionPreset) {
    assert(_memory != null);
    _sessionPreset = sessionPreset;
    MediaMixerPlatformInterface.instance.setSessionPreset(
        {"memory": _memory, "value": sessionPreset.presetName});
  }

  /// Gets the screen properties.
  ScreenSettings get screenSettings => _screenSettings;

  /// Sets the screen properties.
  set screenSettings(ScreenSettings screenSettings) {
    assert(_memory != null);
    _screenSettings = screenSettings;
    MediaMixerPlatformInterface.instance.setScreenSettings(
        {"memory": _memory, "settings": screenSettings.toMap()});
  }

  Future<void> setHasAudio(bool value) async {
    assert(_memory != null);
    MediaMixerPlatformInterface.instance
        .setHasAudio({"memory": _memory, "value": value});
  }

  Future<bool?> getHasAudio() {
    assert(_memory != null);
    return MediaMixerPlatformInterface.instance
        .getHasAudio({"memory": _memory});
  }

  Future<void> setHasVideo(bool value) async {
    assert(_memory != null);
    return MediaMixerPlatformInterface.instance
        .setHasVideo({"memory": _memory, "value": value});
  }

  Future<bool?> getHasVideo() {
    assert(_memory != null);
    return MediaMixerPlatformInterface.instance
        .getHasVideo({"memory": _memory});
  }

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
      await MediaMixerPlatformInterface.instance.attachVideo(
          {"memory": _memory, "source": video?.toMap(), "track": track});
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
