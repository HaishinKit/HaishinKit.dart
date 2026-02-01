import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_mixer_settings.freezed.dart';
part 'audio_mixer_settings.g.dart';

/// Constraints on the audio mixier settings.
@freezed
class AudioMixerSettings with _$AudioMixerSettings {
  const factory AudioMixerSettings(
      {@Default(0) int channels,
      @Default(false) bool isMuted,
      @Default(0) int mainTrack,
      @Default(2) int maximumNumberOfChannels,
      @Default(0.0) double sampleRate}) = _AudioMixerSettings;

  factory AudioMixerSettings.fromJson(Map<String, dynamic> json) =>
      _$AudioMixerSettingsFromJson(json);
}
