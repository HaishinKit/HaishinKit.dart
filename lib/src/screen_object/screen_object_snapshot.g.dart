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
      size: ScreenObjectSize.fromJson(json['size'] as Map<String, dynamic>),
      isVisible: json['isVisible'] as bool,
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
      'size': instance.size,
      'isVisible': instance.isVisible,
      'layoutMargin': instance.layoutMargin,
      'horizontalAlignment': instance.horizontalAlignment,
      'verticalAlignment': instance.verticalAlignment,
      'elements': instance.elements,
      'children': instance.children,
    };
