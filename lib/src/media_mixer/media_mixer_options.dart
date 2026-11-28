import 'package:freezed_annotation/freezed_annotation.dart';
import 'dynamic_range_mode.dart';

part 'media_mixer_options.freezed.dart';
part 'media_mixer_options.g.dart';

/// Determines how the native mixer manages capture on Apple platforms.
@JsonEnum(fieldRename: FieldRename.snake)
enum CaptureSessionMode {
  /// Uses a single capture session.
  single,

  /// Uses an Apple multicamera capture session where supported.
  multi,

  /// Uses manual input mode for media supplied by the application.
  manual,
}

/// Configures native dynamic range and Apple capture/audio mixing behavior.
///
/// ```dart
/// final options = MediaMixerOptions(
///   captureSessionMode: CaptureSessionMode.multi,
///   multiTrackAudioMixingEnabled: true,
/// );
/// ```
///
/// Use `copyWith` to create a copy with different settings.
@freezed
abstract class MediaMixerOptions with _$MediaMixerOptions {
  const factory MediaMixerOptions({
    /// Immutable capture/composition range; recreate the mixer to change it.
    @Default(DynamicRangeMode.sdr) DynamicRangeMode dynamicRangeMode,

    /// The capture session mode. Defaults to [CaptureSessionMode.single].
    @Default(CaptureSessionMode.single) CaptureSessionMode captureSessionMode,

    /// Whether to mix multiple audio tracks. Defaults to `false`.
    @Default(false) bool multiTrackAudioMixingEnabled,
  }) = _MediaMixerOptions;

  factory MediaMixerOptions.fromJson(Map<String, dynamic> json) =>
      _$MediaMixerOptionsFromJson(json);
}
