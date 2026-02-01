// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_source.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoSourceImpl _$$VideoSourceImplFromJson(Map<String, dynamic> json) =>
    _$VideoSourceImpl(
      id: json['id'] as String,
      name: json['name'] as String?,
      position:
          $enumDecodeNullable(_$CameraPositionEnumMap, json['position']) ??
              CameraPosition.unspecified,
    );

Map<String, dynamic> _$$VideoSourceImplToJson(_$VideoSourceImpl instance) =>
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
