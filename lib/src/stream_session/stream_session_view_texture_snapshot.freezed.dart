// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_session_view_texture_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StreamSessionViewTextureSnapshot _$StreamSessionViewTextureSnapshotFromJson(
    Map<String, dynamic> json) {
  return _StreamSessionViewTextureSnapshot.fromJson(json);
}

/// @nodoc
mixin _$StreamSessionViewTextureSnapshot {
  double get width => throw _privateConstructorUsedError;
  double get height => throw _privateConstructorUsedError;
  VideoGravity get videoGravity => throw _privateConstructorUsedError;

  /// Serializes this StreamSessionViewTextureSnapshot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of StreamSessionViewTextureSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StreamSessionViewTextureSnapshotCopyWith<StreamSessionViewTextureSnapshot>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreamSessionViewTextureSnapshotCopyWith<$Res> {
  factory $StreamSessionViewTextureSnapshotCopyWith(
          StreamSessionViewTextureSnapshot value,
          $Res Function(StreamSessionViewTextureSnapshot) then) =
      _$StreamSessionViewTextureSnapshotCopyWithImpl<$Res,
          StreamSessionViewTextureSnapshot>;
  @useResult
  $Res call({double width, double height, VideoGravity videoGravity});
}

/// @nodoc
class _$StreamSessionViewTextureSnapshotCopyWithImpl<$Res,
        $Val extends StreamSessionViewTextureSnapshot>
    implements $StreamSessionViewTextureSnapshotCopyWith<$Res> {
  _$StreamSessionViewTextureSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StreamSessionViewTextureSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? videoGravity = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      videoGravity: null == videoGravity
          ? _value.videoGravity
          : videoGravity // ignore: cast_nullable_to_non_nullable
              as VideoGravity,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreamSessionViewTextureSnapshotImplCopyWith<$Res>
    implements $StreamSessionViewTextureSnapshotCopyWith<$Res> {
  factory _$$StreamSessionViewTextureSnapshotImplCopyWith(
          _$StreamSessionViewTextureSnapshotImpl value,
          $Res Function(_$StreamSessionViewTextureSnapshotImpl) then) =
      __$$StreamSessionViewTextureSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double width, double height, VideoGravity videoGravity});
}

/// @nodoc
class __$$StreamSessionViewTextureSnapshotImplCopyWithImpl<$Res>
    extends _$StreamSessionViewTextureSnapshotCopyWithImpl<$Res,
        _$StreamSessionViewTextureSnapshotImpl>
    implements _$$StreamSessionViewTextureSnapshotImplCopyWith<$Res> {
  __$$StreamSessionViewTextureSnapshotImplCopyWithImpl(
      _$StreamSessionViewTextureSnapshotImpl _value,
      $Res Function(_$StreamSessionViewTextureSnapshotImpl) _then)
      : super(_value, _then);

  /// Create a copy of StreamSessionViewTextureSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
    Object? videoGravity = null,
  }) {
    return _then(_$StreamSessionViewTextureSnapshotImpl(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as double,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as double,
      videoGravity: null == videoGravity
          ? _value.videoGravity
          : videoGravity // ignore: cast_nullable_to_non_nullable
              as VideoGravity,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreamSessionViewTextureSnapshotImpl
    implements _StreamSessionViewTextureSnapshot {
  const _$StreamSessionViewTextureSnapshotImpl(
      {this.width = 0.0,
      this.height = 0.0,
      this.videoGravity = VideoGravity.resizeAspect});

  factory _$StreamSessionViewTextureSnapshotImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$StreamSessionViewTextureSnapshotImplFromJson(json);

  @override
  @JsonKey()
  final double width;
  @override
  @JsonKey()
  final double height;
  @override
  @JsonKey()
  final VideoGravity videoGravity;

  @override
  String toString() {
    return 'StreamSessionViewTextureSnapshot(width: $width, height: $height, videoGravity: $videoGravity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreamSessionViewTextureSnapshotImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            (identical(other.videoGravity, videoGravity) ||
                other.videoGravity == videoGravity));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, width, height, videoGravity);

  /// Create a copy of StreamSessionViewTextureSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StreamSessionViewTextureSnapshotImplCopyWith<
          _$StreamSessionViewTextureSnapshotImpl>
      get copyWith => __$$StreamSessionViewTextureSnapshotImplCopyWithImpl<
          _$StreamSessionViewTextureSnapshotImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreamSessionViewTextureSnapshotImplToJson(
      this,
    );
  }
}

abstract class _StreamSessionViewTextureSnapshot
    implements StreamSessionViewTextureSnapshot {
  const factory _StreamSessionViewTextureSnapshot(
          {final double width,
          final double height,
          final VideoGravity videoGravity}) =
      _$StreamSessionViewTextureSnapshotImpl;

  factory _StreamSessionViewTextureSnapshot.fromJson(
          Map<String, dynamic> json) =
      _$StreamSessionViewTextureSnapshotImpl.fromJson;

  @override
  double get width;
  @override
  double get height;
  @override
  VideoGravity get videoGravity;

  /// Create a copy of StreamSessionViewTextureSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StreamSessionViewTextureSnapshotImplCopyWith<
          _$StreamSessionViewTextureSnapshotImpl>
      get copyWith => throw _privateConstructorUsedError;
}
