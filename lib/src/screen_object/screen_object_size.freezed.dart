// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_object_size.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
ScreenObjectSize _$ScreenObjectSizeFromJson(
  Map<String, dynamic> json
) {
    return _ScreenObjectRect.fromJson(
      json
    );
}

/// @nodoc
mixin _$ScreenObjectSize {

/// The width of the screen object.
 int get width;/// The height of the screen object.
 int get height;
/// Create a copy of ScreenObjectSize
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenObjectSizeCopyWith<ScreenObjectSize> get copyWith => _$ScreenObjectSizeCopyWithImpl<ScreenObjectSize>(this as ScreenObjectSize, _$identity);

  /// Serializes this ScreenObjectSize to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenObjectSize&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height);

@override
String toString() {
  return 'ScreenObjectSize(width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class $ScreenObjectSizeCopyWith<$Res>  {
  factory $ScreenObjectSizeCopyWith(ScreenObjectSize value, $Res Function(ScreenObjectSize) _then) = _$ScreenObjectSizeCopyWithImpl;
@useResult
$Res call({
 int width, int height
});




}
/// @nodoc
class _$ScreenObjectSizeCopyWithImpl<$Res>
    implements $ScreenObjectSizeCopyWith<$Res> {
  _$ScreenObjectSizeCopyWithImpl(this._self, this._then);

  final ScreenObjectSize _self;
  final $Res Function(ScreenObjectSize) _then;

/// Create a copy of ScreenObjectSize
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ScreenObjectSize].
extension ScreenObjectSizePatterns on ScreenObjectSize {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenObjectRect value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenObjectRect() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenObjectRect value)  $default,){
final _that = this;
switch (_that) {
case _ScreenObjectRect():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenObjectRect value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenObjectRect() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int width,  int height)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenObjectRect() when $default != null:
return $default(_that.width,_that.height);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int width,  int height)  $default,) {final _that = this;
switch (_that) {
case _ScreenObjectRect():
return $default(_that.width,_that.height);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int width,  int height)?  $default,) {final _that = this;
switch (_that) {
case _ScreenObjectRect() when $default != null:
return $default(_that.width,_that.height);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenObjectRect implements ScreenObjectSize {
  const _ScreenObjectRect({required this.width, required this.height});
  factory _ScreenObjectRect.fromJson(Map<String, dynamic> json) => _$ScreenObjectRectFromJson(json);

/// The width of the screen object.
@override final  int width;
/// The height of the screen object.
@override final  int height;

/// Create a copy of ScreenObjectSize
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenObjectRectCopyWith<_ScreenObjectRect> get copyWith => __$ScreenObjectRectCopyWithImpl<_ScreenObjectRect>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenObjectRectToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenObjectRect&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height);

@override
String toString() {
  return 'ScreenObjectSize(width: $width, height: $height)';
}


}

/// @nodoc
abstract mixin class _$ScreenObjectRectCopyWith<$Res> implements $ScreenObjectSizeCopyWith<$Res> {
  factory _$ScreenObjectRectCopyWith(_ScreenObjectRect value, $Res Function(_ScreenObjectRect) _then) = __$ScreenObjectRectCopyWithImpl;
@override @useResult
$Res call({
 int width, int height
});




}
/// @nodoc
class __$ScreenObjectRectCopyWithImpl<$Res>
    implements _$ScreenObjectRectCopyWith<$Res> {
  __$ScreenObjectRectCopyWithImpl(this._self, this._then);

  final _ScreenObjectRect _self;
  final $Res Function(_ScreenObjectRect) _then;

/// Create a copy of ScreenObjectSize
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,}) {
  return _then(_ScreenObjectRect(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as int,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
