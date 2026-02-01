// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'screen_object_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScreenObjectSnapshotImpl _$$ScreenObjectSnapshotImplFromJson(
        Map<String, dynamic> json) =>
    _$ScreenObjectSnapshotImpl(
      type: json['type'] as String,
      id: json['id'] as String,
      frame: ScreenObjectRect.fromJson(json['frame'] as Map<String, dynamic>),
      layoutMargin: ScreenObjectEdgeInsets.fromJson(
          json['layoutMargin'] as Map<String, dynamic>),
      horizontalAlignment: (json['horizontalAlignment'] as num).toInt(),
      verticalAlignment: (json['verticalAlignment'] as num).toInt(),
      elements: Map<String, String>.from(json['elements'] as Map),
      children: (json['children'] as List<dynamic>)
          .map((e) => ScreenObjectSnapshot.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$ScreenObjectSnapshotImplToJson(
        _$ScreenObjectSnapshotImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'frame': instance.frame,
      'layoutMargin': instance.layoutMargin,
      'horizontalAlignment': instance.horizontalAlignment,
      'verticalAlignment': instance.verticalAlignment,
      'elements': instance.elements,
      'children': instance.children,
    };
