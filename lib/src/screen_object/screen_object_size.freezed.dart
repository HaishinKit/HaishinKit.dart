// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_object_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScreenObjectSize _$ScreenObjectSizeFromJson(Map<String, dynamic> json) {
  return _ScreenObjectRect.fromJson(json);
}

/// @nodoc
mixin _$ScreenObjectSize {
  /// The width of the rectangle.
  int get width => throw _privateConstructorUsedError;

  /// The height of the rectangle.
  int get height => throw _privateConstructorUsedError;

  /// Serializes this ScreenObjectSize to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScreenObjectSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScreenObjectSizeCopyWith<ScreenObjectSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenObjectSizeCopyWith<$Res> {
  factory $ScreenObjectSizeCopyWith(
          ScreenObjectSize value, $Res Function(ScreenObjectSize) then) =
      _$ScreenObjectSizeCopyWithImpl<$Res, ScreenObjectSize>;
  @useResult
  $Res call({int width, int height});
}

/// @nodoc
class _$ScreenObjectSizeCopyWithImpl<$Res, $Val extends ScreenObjectSize>
    implements $ScreenObjectSizeCopyWith<$Res> {
  _$ScreenObjectSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScreenObjectSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScreenObjectRectImplCopyWith<$Res>
    implements $ScreenObjectSizeCopyWith<$Res> {
  factory _$$ScreenObjectRectImplCopyWith(_$ScreenObjectRectImpl value,
          $Res Function(_$ScreenObjectRectImpl) then) =
      __$$ScreenObjectRectImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int width, int height});
}

/// @nodoc
class __$$ScreenObjectRectImplCopyWithImpl<$Res>
    extends _$ScreenObjectSizeCopyWithImpl<$Res, _$ScreenObjectRectImpl>
    implements _$$ScreenObjectRectImplCopyWith<$Res> {
  __$$ScreenObjectRectImplCopyWithImpl(_$ScreenObjectRectImpl _value,
      $Res Function(_$ScreenObjectRectImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScreenObjectSize
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$ScreenObjectRectImpl(
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScreenObjectRectImpl implements _ScreenObjectRect {
  const _$ScreenObjectRectImpl({required this.width, required this.height});

  factory _$ScreenObjectRectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScreenObjectRectImplFromJson(json);

  /// The width of the rectangle.
  @override
  final int width;

  /// The height of the rectangle.
  @override
  final int height;

  @override
  String toString() {
    return 'ScreenObjectSize(width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScreenObjectRectImpl &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, width, height);

  /// Create a copy of ScreenObjectSize
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScreenObjectRectImplCopyWith<_$ScreenObjectRectImpl> get copyWith =>
      __$$ScreenObjectRectImplCopyWithImpl<_$ScreenObjectRectImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScreenObjectRectImplToJson(
      this,
    );
  }
}

abstract class _ScreenObjectRect implements ScreenObjectSize {
  const factory _ScreenObjectRect(
      {required final int width,
      required final int height}) = _$ScreenObjectRectImpl;

  factory _ScreenObjectRect.fromJson(Map<String, dynamic> json) =
      _$ScreenObjectRectImpl.fromJson;

  /// The width of the rectangle.
  @override
  int get width;

  /// The height of the rectangle.
  @override
  int get height;

  /// Create a copy of ScreenObjectSize
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScreenObjectRectImplCopyWith<_$ScreenObjectRectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
