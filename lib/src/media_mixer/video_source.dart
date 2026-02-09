import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'video_source.freezed.dart';

part 'video_source.g.dart';

/// Represents the position of the camera.
enum CameraPosition {
  /// Front-facing camera.
  front,

  /// Rear-facing (back) camera.
  back,

  /// Camera position is not specified.
  unspecified,
}

/// Represents a video input source.
@freezed
class VideoSource with _$VideoSource {
  const factory VideoSource({
    /// Unique identifier of the video source.
    required String id,

    /// Optional display name of the video source.
    String? name,

    /// Camera position used by this video source.
    ///
    /// Defaults to [CameraPosition.unspecified] when not explicitly set.
    @Default(CameraPosition.unspecified) CameraPosition position,
  }) = _VideoSource;

  /// Creates a [VideoSource] instance from JSON.
  factory VideoSource.fromJson(Map<String, dynamic> json) =>
      _$VideoSourceFromJson(json);
}
