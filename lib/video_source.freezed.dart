// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoSource _$VideoSourceFromJson(Map<String, dynamic> json) {
  return _VideoSource.fromJson(json);
}

/// @nodoc
mixin _$VideoSource {
  /// Unique identifier of the video source.
  String get id => throw _privateConstructorUsedError;

  /// Optional display name of the video source.
  String? get name => throw _privateConstructorUsedError;

  /// Camera position used by this video source.
  ///
  /// Defaults to [CameraPosition.unspecified] when not explicitly set.
  CameraPosition get position => throw _privateConstructorUsedError;

  /// Serializes this VideoSource to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoSourceCopyWith<VideoSource> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoSourceCopyWith<$Res> {
  factory $VideoSourceCopyWith(
          VideoSource value, $Res Function(VideoSource) then) =
      _$VideoSourceCopyWithImpl<$Res, VideoSource>;

  @useResult
  $Res call({String id, String? name, CameraPosition position});
}

/// @nodoc
class _$VideoSourceCopyWithImpl<$Res, $Val extends VideoSource>
    implements $VideoSourceCopyWith<$Res> {
  _$VideoSourceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? position = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as CameraPosition,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoSourceImplCopyWith<$Res>
    implements $VideoSourceCopyWith<$Res> {
  factory _$$VideoSourceImplCopyWith(
          _$VideoSourceImpl value, $Res Function(_$VideoSourceImpl) then) =
      __$$VideoSourceImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({String id, String? name, CameraPosition position});
}

/// @nodoc
class __$$VideoSourceImplCopyWithImpl<$Res>
    extends _$VideoSourceCopyWithImpl<$Res, _$VideoSourceImpl>
    implements _$$VideoSourceImplCopyWith<$Res> {
  __$$VideoSourceImplCopyWithImpl(
      _$VideoSourceImpl _value, $Res Function(_$VideoSourceImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoSource
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = freezed,
    Object? position = null,
  }) {
    return _then(_$VideoSourceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as CameraPosition,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoSourceImpl with DiagnosticableTreeMixin implements _VideoSource {
  const _$VideoSourceImpl(
      {required this.id,
      this.name,
      this.position = CameraPosition.unspecified});

  factory _$VideoSourceImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoSourceImplFromJson(json);

  /// Unique identifier of the video source.
  @override
  final String id;

  /// Optional display name of the video source.
  @override
  final String? name;

  /// Camera position used by this video source.
  ///
  /// Defaults to [CameraPosition.unspecified] when not explicitly set.
  @override
  @JsonKey()
  final CameraPosition position;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoSource(id: $id, name: $name, position: $position)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoSource'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('position', position));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoSourceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, position);

  /// Create a copy of VideoSource
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoSourceImplCopyWith<_$VideoSourceImpl> get copyWith =>
      __$$VideoSourceImplCopyWithImpl<_$VideoSourceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoSourceImplToJson(
      this,
    );
  }
}

abstract class _VideoSource implements VideoSource {
  const factory _VideoSource(
      {required final String id,
      final String? name,
      final CameraPosition position}) = _$VideoSourceImpl;

  factory _VideoSource.fromJson(Map<String, dynamic> json) =
      _$VideoSourceImpl.fromJson;

  /// Unique identifier of the video source.
  @override
  String get id;

  /// Optional display name of the video source.
  @override
  String? get name;

  /// Camera position used by this video source.
  ///
  /// Defaults to [CameraPosition.unspecified] when not explicitly set.
  @override
  CameraPosition get position;

  /// Create a copy of VideoSource
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoSourceImplCopyWith<_$VideoSourceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
