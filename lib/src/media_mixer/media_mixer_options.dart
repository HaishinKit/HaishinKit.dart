import 'package:freezed_annotation/freezed_annotation.dart';

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
  manual
}

/// Configures native capture and audio mixing on Apple platforms.
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
    /// The capture session mode. Defaults to [CaptureSessionMode.single].
    @Default(CaptureSessionMode.single)
    CaptureSessionMode captureSessionMode,

    /// Whether to mix multiple audio tracks. Defaults to `false`.
    @Default(false)
    bool multiTrackAudioMixingEnabled,
  }) = _MediaMixerOptions;

  factory MediaMixerOptions.fromJson(Map<String, dynamic> json) =>
      _$MediaMixerOptionsFromJson(json);
}
