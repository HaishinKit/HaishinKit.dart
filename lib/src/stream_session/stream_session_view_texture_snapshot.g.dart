// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stream_session_view_texture_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StreamSessionViewTextureSnapshotImpl
    _$$StreamSessionViewTextureSnapshotImplFromJson(
            Map<String, dynamic> json) =>
        _$StreamSessionViewTextureSnapshotImpl(
          width: (json['width'] as num?)?.toDouble() ?? 0.0,
          height: (json['height'] as num?)?.toDouble() ?? 0.0,
          videoGravity: $enumDecodeNullable(
                  _$VideoGravityEnumMap, json['videoGravity']) ??
              VideoGravity.resizeAspect,
        );

Map<String, dynamic> _$$StreamSessionViewTextureSnapshotImplToJson(
        _$StreamSessionViewTextureSnapshotImpl instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'videoGravity': _$VideoGravityEnumMap[instance.videoGravity]!,
    };

const _$VideoGravityEnumMap = {
  VideoGravity.resize: 'resize',
  VideoGravity.resizeAspect: 'resizeAspect',
  VideoGravity.resizeAspectFill: 'resizeAspectFill',
};
