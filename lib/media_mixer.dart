import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/media_mixer_platform_interface.dart';
import 'package:haishin_kit/screen_settings.dart';
import 'package:haishin_kit/video_source.dart';

import 'audio_source.dart';
import 'av_capture_session_preset.dart';

class MediaMixer {
  static Future<MediaMixer> create() async {
    var object = MediaMixer._();
    object._memory = await HaishinKitPlatform.instance.newMediaMixer();
    return object;
  }

  int? _memory;
  int _frameRate = 30;
  AVCaptureSessionPreset _sessionPreset = AVCaptureSessionPreset.hd1280x720;
  ScreenSettings _screenSettings = ScreenSettings();

  MediaMixer._();

  int? get memory => _memory;

  int get frameRate => _frameRate;

  set frameRate(int frameRate) {
    assert(_memory != null);
    _frameRate = frameRate;
    MediaMixerPlatform.instance
        .setFrameRate({"memory": _memory, "value": frameRate});
  }

  AVCaptureSessionPreset get sessionPreset => _sessionPreset;

  set sessionPreset(AVCaptureSessionPreset sessionPreset) {
    assert(_memory != null);
    _sessionPreset = sessionPreset;
    MediaMixerPlatform.instance.setSessionPreset(
        {"memory": _memory, "value": sessionPreset.presetName});
  }

  ScreenSettings get screenSettings => _screenSettings;

  set screenSettings(ScreenSettings screenSettings) {
    assert(_memory != null);
    _screenSettings = screenSettings;
    MediaMixerPlatform.instance.setScreenSettings(
        {"memory": _memory, "settings": screenSettings.toMap()});
  }

  Future<void> setHasAudio(bool value) async {
    assert(_memory != null);
    MediaMixerPlatform.instance
        .setHasAudio({"memory": _memory, "value": value});
  }

  Future<bool?> getHasAudio() {
    assert(_memory != null);
    return MediaMixerPlatform.instance.getHasAudio({"memory": _memory});
  }

  Future<void> setHasVideo(bool value) async {
    assert(_memory != null);
    return MediaMixerPlatform.instance
        .setHasVideo({"memory": _memory, "value": value});
  }

  Future<bool?> getHasVideo() {
    assert(_memory != null);
    return MediaMixerPlatform.instance.getHasVideo({"memory": _memory});
  }

  Future<void> attachAudio(int track, AudioSource? audio) async {
    assert(_memory != null);
    return MediaMixerPlatform.instance.attachAudio(
        {"memory": _memory, "source": audio?.toMap(), "track": track});
  }

  Future<void> attachVideo(int track, VideoSource? video) async {
    assert(_memory != null);
    return MediaMixerPlatform.instance.attachVideo(
        {"memory": _memory, "source": video?.toMap(), "track": track});
  }

  Future<void> startRunning() async {
    assert(_memory != null);
    return MediaMixerPlatform.instance.startRunning({"memory": _memory});
  }

  Future<void> stopRunning() async {
    assert(_memory != null);
    return MediaMixerPlatform.instance.stopRunning({"memory": _memory});
  }

  Future<void> dispose() async {
    assert(_memory != null);
    return MediaMixerPlatform.instance.dispose({"memory": _memory});
  }
}
