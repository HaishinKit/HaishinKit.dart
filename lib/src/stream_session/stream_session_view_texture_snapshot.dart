import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:haishin_kit/src/haishin_kit/video_gravity.dart';

part 'stream_session_view_texture_snapshot.freezed.dart';

part 'stream_session_view_texture_snapshot.g.dart';

@freezed
class StreamSessionViewTextureSnapshot with _$StreamSessionViewTextureSnapshot {
  const factory StreamSessionViewTextureSnapshot(
          {@Default(0.0) double width,
          @Default(0.0) double height,
          @Default(VideoGravity.resizeAspect) VideoGravity videoGravity}) =
      _StreamSessionViewTextureSnapshot;

  factory StreamSessionViewTextureSnapshot.fromJson(
          Map<String, dynamic> json) =>
      _$StreamSessionViewTextureSnapshotFromJson(json);
}
