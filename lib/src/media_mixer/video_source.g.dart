// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoSource _$VideoSourceFromJson(Map<String, dynamic> json) => _VideoSource(
  id: json['id'] as String,
  name: json['name'] as String?,
  position:
      $enumDecodeNullable(_$CameraPositionEnumMap, json['position']) ??
      CameraPosition.unspecified,
);

Map<String, dynamic> _$VideoSourceToJson(_VideoSource instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': _$CameraPositionEnumMap[instance.position]!,
    };

const _$CameraPositionEnumMap = {
  CameraPosition.front: 'front',
  CameraPosition.back: 'back',
  CameraPosition.unspecified: 'unspecified',
};
