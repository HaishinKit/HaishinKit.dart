// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_object_rect.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScreenObjectRect _$ScreenObjectRectFromJson(Map<String, dynamic> json) {
  return _ScreenObjectRect.fromJson(json);
}

/// @nodoc
mixin _$ScreenObjectRect {
  /// The horizontal position of the rectangle's top-left corner.
  int get x => throw _privateConstructorUsedError;

  ///  The vertical position of the rectangle's top-left corner.
  int get y => throw _privateConstructorUsedError;

  /// The width of the rectangle.
  int get width => throw _privateConstructorUsedError;

  /// The height of the rectangle.
  int get height => throw _privateConstructorUsedError;

  /// Serializes this ScreenObjectRect to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScreenObjectRect
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScreenObjectRectCopyWith<ScreenObjectRect> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenObjectRectCopyWith<$Res> {
  factory $ScreenObjectRectCopyWith(
          ScreenObjectRect value, $Res Function(ScreenObjectRect) then) =
      _$ScreenObjectRectCopyWithImpl<$Res, ScreenObjectRect>;

  @useResult
  $Res call({int x, int y, int width, int height});
}

/// @nodoc
class _$ScreenObjectRectCopyWithImpl<$Res, $Val extends ScreenObjectRect>
    implements $ScreenObjectRectCopyWith<$Res> {
  _$ScreenObjectRectCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScreenObjectRect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_value.copyWith(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as int,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as int,
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
    implements $ScreenObjectRectCopyWith<$Res> {
  factory _$$ScreenObjectRectImplCopyWith(_$ScreenObjectRectImpl value,
          $Res Function(_$ScreenObjectRectImpl) then) =
      __$$ScreenObjectRectImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({int x, int y, int width, int height});
}

/// @nodoc
class __$$ScreenObjectRectImplCopyWithImpl<$Res>
    extends _$ScreenObjectRectCopyWithImpl<$Res, _$ScreenObjectRectImpl>
    implements _$$ScreenObjectRectImplCopyWith<$Res> {
  __$$ScreenObjectRectImplCopyWithImpl(_$ScreenObjectRectImpl _value,
      $Res Function(_$ScreenObjectRectImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScreenObjectRect
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? x = null,
    Object? y = null,
    Object? width = null,
    Object? height = null,
  }) {
    return _then(_$ScreenObjectRectImpl(
      x: null == x
          ? _value.x
          : x // ignore: cast_nullable_to_non_nullable
              as int,
      y: null == y
          ? _value.y
          : y // ignore: cast_nullable_to_non_nullable
              as int,
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
  const _$ScreenObjectRectImpl(
      {required this.x,
      required this.y,
      required this.width,
      required this.height});

  factory _$ScreenObjectRectImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScreenObjectRectImplFromJson(json);

  /// The horizontal position of the rectangle's top-left corner.
  @override
  final int x;

  ///  The vertical position of the rectangle's top-left corner.
  @override
  final int y;

  /// The width of the rectangle.
  @override
  final int width;

  /// The height of the rectangle.
  @override
  final int height;

  @override
  String toString() {
    return 'ScreenObjectRect(x: $x, y: $y, width: $width, height: $height)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScreenObjectRectImpl &&
            (identical(other.x, x) || other.x == x) &&
            (identical(other.y, y) || other.y == y) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, x, y, width, height);

  /// Create a copy of ScreenObjectRect
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

abstract class _ScreenObjectRect implements ScreenObjectRect {
  const factory _ScreenObjectRect(
      {required final int x,
      required final int y,
      required final int width,
      required final int height}) = _$ScreenObjectRectImpl;

  factory _ScreenObjectRect.fromJson(Map<String, dynamic> json) =
      _$ScreenObjectRectImpl.fromJson;

  /// The horizontal position of the rectangle's top-left corner.
  @override
  int get x;

  ///  The vertical position of the rectangle's top-left corner.
  @override
  int get y;

  /// The width of the rectangle.
  @override
  int get width;

  /// The height of the rectangle.
  @override
  int get height;

  /// Create a copy of ScreenObjectRect
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScreenObjectRectImplCopyWith<_$ScreenObjectRectImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
