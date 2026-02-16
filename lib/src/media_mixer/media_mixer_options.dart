import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_mixer_options.freezed.dart';
part 'media_mixer_options.g.dart';

/// Specifies the capture session mode used by the media mixer.
///
/// This enum defines how capture sessions are managed:
///
/// - [single]: Uses a single capture session. This is the default mode and is
///   suitable for most use cases where only one input source is required.
/// - [multi]: Uses multiple capture sessions simultaneously. This mode enables
///   handling multiple input sources independently.
/// - [manual]: Uses a manually managed capture session. This mode allows the
///   application to control the capture session lifecycle and configuration.
@JsonEnum(fieldRename: FieldRename.snake)
enum CaptureSessionMode {
  /// Uses a single capture session.
  single,

  /// Uses multiple capture sessions.
  multi,

  /// Uses a manually managed capture session.
  manual
}

/// Configuration options for the media mixer.
///
/// This class defines how the media mixer captures and mixes audio and video.
/// It supports JSON serialization/deserialization via `freezed` and `json_serializable`.
///
/// Example:
/// ```dart
/// final options = MediaMixerOptions(
///   captureSessionMode: CaptureSessionMode.multi,
///   multiTrackAudioMixingEnabled: true,
/// );
/// ```
///
/// This class is immutable. To modify values, use `copyWith`.
@freezed
class MediaMixerOptions with _$MediaMixerOptions {
  const factory MediaMixerOptions({
    /// Specifies how capture sessions are managed. iOS only.
    @Default(CaptureSessionMode.single)
    CaptureSessionMode captureSessionMode,

    /// Enables mixing multiple audio tracks independently when set to true. Defaults to false. iOS Only.
    @Default(false)
    bool multiTrackAudioMixingEnabled,
  }) = _MediaMixerOptions;

  factory MediaMixerOptions.fromJson(Map<String, dynamic> json) =>
      _$MediaMixerOptionsFromJson(json);
}
