// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stream_session_view_texture_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StreamSessionViewTextureSnapshot {

 double get width; double get height; VideoGravity get videoGravity;
/// Create a copy of StreamSessionViewTextureSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreamSessionViewTextureSnapshotCopyWith<StreamSessionViewTextureSnapshot> get copyWith => _$StreamSessionViewTextureSnapshotCopyWithImpl<StreamSessionViewTextureSnapshot>(this as StreamSessionViewTextureSnapshot, _$identity);

  /// Serializes this StreamSessionViewTextureSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreamSessionViewTextureSnapshot&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.videoGravity, videoGravity) || other.videoGravity == videoGravity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,videoGravity);

@override
String toString() {
  return 'StreamSessionViewTextureSnapshot(width: $width, height: $height, videoGravity: $videoGravity)';
}


}

/// @nodoc
abstract mixin class $StreamSessionViewTextureSnapshotCopyWith<$Res>  {
  factory $StreamSessionViewTextureSnapshotCopyWith(StreamSessionViewTextureSnapshot value, $Res Function(StreamSessionViewTextureSnapshot) _then) = _$StreamSessionViewTextureSnapshotCopyWithImpl;
@useResult
$Res call({
 double width, double height, VideoGravity videoGravity
});




}
/// @nodoc
class _$StreamSessionViewTextureSnapshotCopyWithImpl<$Res>
    implements $StreamSessionViewTextureSnapshotCopyWith<$Res> {
  _$StreamSessionViewTextureSnapshotCopyWithImpl(this._self, this._then);

  final StreamSessionViewTextureSnapshot _self;
  final $Res Function(StreamSessionViewTextureSnapshot) _then;

/// Create a copy of StreamSessionViewTextureSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? width = null,Object? height = null,Object? videoGravity = null,}) {
  return _then(_self.copyWith(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,videoGravity: null == videoGravity ? _self.videoGravity : videoGravity // ignore: cast_nullable_to_non_nullable
as VideoGravity,
  ));
}

}


/// Adds pattern-matching-related methods to [StreamSessionViewTextureSnapshot].
extension StreamSessionViewTextureSnapshotPatterns on StreamSessionViewTextureSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreamSessionViewTextureSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreamSessionViewTextureSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreamSessionViewTextureSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _StreamSessionViewTextureSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreamSessionViewTextureSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _StreamSessionViewTextureSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double width,  double height,  VideoGravity videoGravity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreamSessionViewTextureSnapshot() when $default != null:
return $default(_that.width,_that.height,_that.videoGravity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double width,  double height,  VideoGravity videoGravity)  $default,) {final _that = this;
switch (_that) {
case _StreamSessionViewTextureSnapshot():
return $default(_that.width,_that.height,_that.videoGravity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double width,  double height,  VideoGravity videoGravity)?  $default,) {final _that = this;
switch (_that) {
case _StreamSessionViewTextureSnapshot() when $default != null:
return $default(_that.width,_that.height,_that.videoGravity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StreamSessionViewTextureSnapshot implements StreamSessionViewTextureSnapshot {
  const _StreamSessionViewTextureSnapshot({this.width = 0.0, this.height = 0.0, this.videoGravity = VideoGravity.resizeAspect});
  factory _StreamSessionViewTextureSnapshot.fromJson(Map<String, dynamic> json) => _$StreamSessionViewTextureSnapshotFromJson(json);

@override@JsonKey() final  double width;
@override@JsonKey() final  double height;
@override@JsonKey() final  VideoGravity videoGravity;

/// Create a copy of StreamSessionViewTextureSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreamSessionViewTextureSnapshotCopyWith<_StreamSessionViewTextureSnapshot> get copyWith => __$StreamSessionViewTextureSnapshotCopyWithImpl<_StreamSessionViewTextureSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StreamSessionViewTextureSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreamSessionViewTextureSnapshot&&(identical(other.width, width) || other.width == width)&&(identical(other.height, height) || other.height == height)&&(identical(other.videoGravity, videoGravity) || other.videoGravity == videoGravity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,width,height,videoGravity);

@override
String toString() {
  return 'StreamSessionViewTextureSnapshot(width: $width, height: $height, videoGravity: $videoGravity)';
}


}

/// @nodoc
abstract mixin class _$StreamSessionViewTextureSnapshotCopyWith<$Res> implements $StreamSessionViewTextureSnapshotCopyWith<$Res> {
  factory _$StreamSessionViewTextureSnapshotCopyWith(_StreamSessionViewTextureSnapshot value, $Res Function(_StreamSessionViewTextureSnapshot) _then) = __$StreamSessionViewTextureSnapshotCopyWithImpl;
@override @useResult
$Res call({
 double width, double height, VideoGravity videoGravity
});




}
/// @nodoc
class __$StreamSessionViewTextureSnapshotCopyWithImpl<$Res>
    implements _$StreamSessionViewTextureSnapshotCopyWith<$Res> {
  __$StreamSessionViewTextureSnapshotCopyWithImpl(this._self, this._then);

  final _StreamSessionViewTextureSnapshot _self;
  final $Res Function(_StreamSessionViewTextureSnapshot) _then;

/// Create a copy of StreamSessionViewTextureSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? width = null,Object? height = null,Object? videoGravity = null,}) {
  return _then(_StreamSessionViewTextureSnapshot(
width: null == width ? _self.width : width // ignore: cast_nullable_to_non_nullable
as double,height: null == height ? _self.height : height // ignore: cast_nullable_to_non_nullable
as double,videoGravity: null == videoGravity ? _self.videoGravity : videoGravity // ignore: cast_nullable_to_non_nullable
as VideoGravity,
  ));
}


}

// dart format on
