// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_session_view_texture_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StreamSessionViewTextureSnapshot _$StreamSessionViewTextureSnapshotFromJson(
  Map<String, dynamic> json,
) => _StreamSessionViewTextureSnapshot(
  width: (json['width'] as num?)?.toDouble() ?? 0.0,
  height: (json['height'] as num?)?.toDouble() ?? 0.0,
  videoGravity:
      $enumDecodeNullable(_$VideoGravityEnumMap, json['videoGravity']) ??
      VideoGravity.resizeAspect,
);

Map<String, dynamic> _$StreamSessionViewTextureSnapshotToJson(
  _StreamSessionViewTextureSnapshot instance,
) => <String, dynamic>{
  'width': instance.width,
  'height': instance.height,
  'videoGravity': _$VideoGravityEnumMap[instance.videoGravity]!,
};

const _$VideoGravityEnumMap = {
  VideoGravity.resize: 'resize',
  VideoGravity.resizeAspect: 'resizeAspect',
  VideoGravity.resizeAspectFill: 'resizeAspectFill',
};
