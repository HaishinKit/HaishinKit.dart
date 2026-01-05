import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'video_mixer_settings.freezed.dart';
part 'video_mixer_settings.g.dart';

/// The type of image rendering mode.
@JsonEnum(fieldRename: FieldRename.snake)
enum VideoRenderingMode {
  /// The input buffer will be used as it is. No effects will be applied.
  passthrough,
  /// Off-screen rendering will be performed to allow for more flexible drawing.
  offscreen
}

/// Constraints on the video mixier settings.
@freezed
class VideoMixerSettings with _$VideoMixerSettings {
  const factory VideoMixerSettings({
    @JsonKey(
      defaultValue: VideoRenderingMode.offscreen,
      unknownEnumValue: VideoRenderingMode.offscreen,
    )
    @Default(VideoRenderingMode.offscreen)
    VideoRenderingMode mode,
    @Default(false) bool isMuted,
    @Default(0) int mainTrack,
  }) = _VideoMixerSettings;

  factory VideoMixerSettings.fromJson(Map<String, dynamic> json) =>
      _$VideoMixerSettingsFromJson(json);
}
