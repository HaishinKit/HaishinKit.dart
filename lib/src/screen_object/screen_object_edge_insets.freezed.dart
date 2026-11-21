// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_object_edge_insets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreenObjectEdgeInsets {

/// The inset on the top side.
 int get top;/// The inset on the left side.
 int get left;/// The inset on the bottom side.
 int get bottom;/// The inset on the right side.
 int get right;
/// Create a copy of ScreenObjectEdgeInsets
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenObjectEdgeInsetsCopyWith<ScreenObjectEdgeInsets> get copyWith => _$ScreenObjectEdgeInsetsCopyWithImpl<ScreenObjectEdgeInsets>(this as ScreenObjectEdgeInsets, _$identity);

  /// Serializes this ScreenObjectEdgeInsets to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenObjectEdgeInsets&&(identical(other.top, top) || other.top == top)&&(identical(other.left, left) || other.left == left)&&(identical(other.bottom, bottom) || other.bottom == bottom)&&(identical(other.right, right) || other.right == right));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,top,left,bottom,right);

@override
String toString() {
  return 'ScreenObjectEdgeInsets(top: $top, left: $left, bottom: $bottom, right: $right)';
}


}

/// @nodoc
abstract mixin class $ScreenObjectEdgeInsetsCopyWith<$Res>  {
  factory $ScreenObjectEdgeInsetsCopyWith(ScreenObjectEdgeInsets value, $Res Function(ScreenObjectEdgeInsets) _then) = _$ScreenObjectEdgeInsetsCopyWithImpl;
@useResult
$Res call({
 int top, int left, int bottom, int right
});




}
/// @nodoc
class _$ScreenObjectEdgeInsetsCopyWithImpl<$Res>
    implements $ScreenObjectEdgeInsetsCopyWith<$Res> {
  _$ScreenObjectEdgeInsetsCopyWithImpl(this._self, this._then);

  final ScreenObjectEdgeInsets _self;
  final $Res Function(ScreenObjectEdgeInsets) _then;

/// Create a copy of ScreenObjectEdgeInsets
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? top = null,Object? left = null,Object? bottom = null,Object? right = null,}) {
  return _then(_self.copyWith(
top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as int,left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as int,bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as int,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenObjectEdgeInsets].
extension ScreenObjectEdgeInsetsPatterns on ScreenObjectEdgeInsets {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenObjectEdgeInsets value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenObjectEdgeInsets() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenObjectEdgeInsets value)  $default,){
final _that = this;
switch (_that) {
case _ScreenObjectEdgeInsets():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenObjectEdgeInsets value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenObjectEdgeInsets() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int top,  int left,  int bottom,  int right)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenObjectEdgeInsets() when $default != null:
return $default(_that.top,_that.left,_that.bottom,_that.right);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int top,  int left,  int bottom,  int right)  $default,) {final _that = this;
switch (_that) {
case _ScreenObjectEdgeInsets():
return $default(_that.top,_that.left,_that.bottom,_that.right);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int top,  int left,  int bottom,  int right)?  $default,) {final _that = this;
switch (_that) {
case _ScreenObjectEdgeInsets() when $default != null:
return $default(_that.top,_that.left,_that.bottom,_that.right);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenObjectEdgeInsets implements ScreenObjectEdgeInsets {
  const _ScreenObjectEdgeInsets({required this.top, required this.left, required this.bottom, required this.right});
  factory _ScreenObjectEdgeInsets.fromJson(Map<String, dynamic> json) => _$ScreenObjectEdgeInsetsFromJson(json);

/// The inset on the top side.
@override final  int top;
/// The inset on the left side.
@override final  int left;
/// The inset on the bottom side.
@override final  int bottom;
/// The inset on the right side.
@override final  int right;

/// Create a copy of ScreenObjectEdgeInsets
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenObjectEdgeInsetsCopyWith<_ScreenObjectEdgeInsets> get copyWith => __$ScreenObjectEdgeInsetsCopyWithImpl<_ScreenObjectEdgeInsets>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenObjectEdgeInsetsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenObjectEdgeInsets&&(identical(other.top, top) || other.top == top)&&(identical(other.left, left) || other.left == left)&&(identical(other.bottom, bottom) || other.bottom == bottom)&&(identical(other.right, right) || other.right == right));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,top,left,bottom,right);

@override
String toString() {
  return 'ScreenObjectEdgeInsets(top: $top, left: $left, bottom: $bottom, right: $right)';
}


}

/// @nodoc
abstract mixin class _$ScreenObjectEdgeInsetsCopyWith<$Res> implements $ScreenObjectEdgeInsetsCopyWith<$Res> {
  factory _$ScreenObjectEdgeInsetsCopyWith(_ScreenObjectEdgeInsets value, $Res Function(_ScreenObjectEdgeInsets) _then) = __$ScreenObjectEdgeInsetsCopyWithImpl;
@override @useResult
$Res call({
 int top, int left, int bottom, int right
});




}
/// @nodoc
class __$ScreenObjectEdgeInsetsCopyWithImpl<$Res>
    implements _$ScreenObjectEdgeInsetsCopyWith<$Res> {
  __$ScreenObjectEdgeInsetsCopyWithImpl(this._self, this._then);

  final _ScreenObjectEdgeInsets _self;
  final $Res Function(_ScreenObjectEdgeInsets) _then;

/// Create a copy of ScreenObjectEdgeInsets
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? top = null,Object? left = null,Object? bottom = null,Object? right = null,}) {
  return _then(_ScreenObjectEdgeInsets(
top: null == top ? _self.top : top // ignore: cast_nullable_to_non_nullable
as int,left: null == left ? _self.left : left // ignore: cast_nullable_to_non_nullable
as int,bottom: null == bottom ? _self.bottom : bottom // ignore: cast_nullable_to_non_nullable
as int,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
