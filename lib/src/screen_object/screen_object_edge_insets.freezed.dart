// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_object_edge_insets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScreenObjectEdgeInsets _$ScreenObjectEdgeInsetsFromJson(
    Map<String, dynamic> json) {
  return _ScreenObjectEdgeInsets.fromJson(json);
}

/// @nodoc
mixin _$ScreenObjectEdgeInsets {
  /// The inset on the top side.
  int get top => throw _privateConstructorUsedError;

  /// The inset on the left side.
  int get left => throw _privateConstructorUsedError;

  /// The inset on the bottom side.
  int get bottom => throw _privateConstructorUsedError;

  /// The inset on the right side.
  int get right => throw _privateConstructorUsedError;

  /// Serializes this ScreenObjectEdgeInsets to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScreenObjectEdgeInsets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScreenObjectEdgeInsetsCopyWith<ScreenObjectEdgeInsets> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenObjectEdgeInsetsCopyWith<$Res> {
  factory $ScreenObjectEdgeInsetsCopyWith(ScreenObjectEdgeInsets value,
          $Res Function(ScreenObjectEdgeInsets) then) =
      _$ScreenObjectEdgeInsetsCopyWithImpl<$Res, ScreenObjectEdgeInsets>;
  @useResult
  $Res call({int top, int left, int bottom, int right});
}

/// @nodoc
class _$ScreenObjectEdgeInsetsCopyWithImpl<$Res,
        $Val extends ScreenObjectEdgeInsets>
    implements $ScreenObjectEdgeInsetsCopyWith<$Res> {
  _$ScreenObjectEdgeInsetsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScreenObjectEdgeInsets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? top = null,
    Object? left = null,
    Object? bottom = null,
    Object? right = null,
  }) {
    return _then(_value.copyWith(
      top: null == top
          ? _value.top
          : top // ignore: cast_nullable_to_non_nullable
              as int,
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as int,
      bottom: null == bottom
          ? _value.bottom
          : bottom // ignore: cast_nullable_to_non_nullable
              as int,
      right: null == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScreenObjectEdgeInsetsImplCopyWith<$Res>
    implements $ScreenObjectEdgeInsetsCopyWith<$Res> {
  factory _$$ScreenObjectEdgeInsetsImplCopyWith(
          _$ScreenObjectEdgeInsetsImpl value,
          $Res Function(_$ScreenObjectEdgeInsetsImpl) then) =
      __$$ScreenObjectEdgeInsetsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int top, int left, int bottom, int right});
}

/// @nodoc
class __$$ScreenObjectEdgeInsetsImplCopyWithImpl<$Res>
    extends _$ScreenObjectEdgeInsetsCopyWithImpl<$Res,
        _$ScreenObjectEdgeInsetsImpl>
    implements _$$ScreenObjectEdgeInsetsImplCopyWith<$Res> {
  __$$ScreenObjectEdgeInsetsImplCopyWithImpl(
      _$ScreenObjectEdgeInsetsImpl _value,
      $Res Function(_$ScreenObjectEdgeInsetsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScreenObjectEdgeInsets
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? top = null,
    Object? left = null,
    Object? bottom = null,
    Object? right = null,
  }) {
    return _then(_$ScreenObjectEdgeInsetsImpl(
      top: null == top
          ? _value.top
          : top // ignore: cast_nullable_to_non_nullable
              as int,
      left: null == left
          ? _value.left
          : left // ignore: cast_nullable_to_non_nullable
              as int,
      bottom: null == bottom
          ? _value.bottom
          : bottom // ignore: cast_nullable_to_non_nullable
              as int,
      right: null == right
          ? _value.right
          : right // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScreenObjectEdgeInsetsImpl implements _ScreenObjectEdgeInsets {
  const _$ScreenObjectEdgeInsetsImpl(
      {required this.top,
      required this.left,
      required this.bottom,
      required this.right});

  factory _$ScreenObjectEdgeInsetsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScreenObjectEdgeInsetsImplFromJson(json);

  /// The inset on the top side.
  @override
  final int top;

  /// The inset on the left side.
  @override
  final int left;

  /// The inset on the bottom side.
  @override
  final int bottom;

  /// The inset on the right side.
  @override
  final int right;

  @override
  String toString() {
    return 'ScreenObjectEdgeInsets(top: $top, left: $left, bottom: $bottom, right: $right)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScreenObjectEdgeInsetsImpl &&
            (identical(other.top, top) || other.top == top) &&
            (identical(other.left, left) || other.left == left) &&
            (identical(other.bottom, bottom) || other.bottom == bottom) &&
            (identical(other.right, right) || other.right == right));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, top, left, bottom, right);

  /// Create a copy of ScreenObjectEdgeInsets
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScreenObjectEdgeInsetsImplCopyWith<_$ScreenObjectEdgeInsetsImpl>
      get copyWith => __$$ScreenObjectEdgeInsetsImplCopyWithImpl<
          _$ScreenObjectEdgeInsetsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScreenObjectEdgeInsetsImplToJson(
      this,
    );
  }
}

abstract class _ScreenObjectEdgeInsets implements ScreenObjectEdgeInsets {
  const factory _ScreenObjectEdgeInsets(
      {required final int top,
      required final int left,
      required final int bottom,
      required final int right}) = _$ScreenObjectEdgeInsetsImpl;

  factory _ScreenObjectEdgeInsets.fromJson(Map<String, dynamic> json) =
      _$ScreenObjectEdgeInsetsImpl.fromJson;

  /// The inset on the top side.
  @override
  int get top;

  /// The inset on the left side.
  @override
  int get left;

  /// The inset on the bottom side.
  @override
  int get bottom;

  /// The inset on the right side.
  @override
  int get right;

  /// Create a copy of ScreenObjectEdgeInsets
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScreenObjectEdgeInsetsImplCopyWith<_$ScreenObjectEdgeInsetsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
