// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_source.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoSource implements DiagnosticableTreeMixin {

/// Unique identifier of the video source.
 String get id;/// Optional display name of the video source.
 String? get name;/// Camera position used by this video source.
///
/// Defaults to [CameraPosition.unspecified] when not explicitly set.
 CameraPosition get position;
/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoSourceCopyWith<VideoSource> get copyWith => _$VideoSourceCopyWithImpl<VideoSource>(this as VideoSource, _$identity);

  /// Serializes this VideoSource to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'VideoSource'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('position', position));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoSource&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'VideoSource(id: $id, name: $name, position: $position)';
}


}

/// @nodoc
abstract mixin class $VideoSourceCopyWith<$Res>  {
  factory $VideoSourceCopyWith(VideoSource value, $Res Function(VideoSource) _then) = _$VideoSourceCopyWithImpl;
@useResult
$Res call({
 String id, String? name, CameraPosition position
});




}
/// @nodoc
class _$VideoSourceCopyWithImpl<$Res>
    implements $VideoSourceCopyWith<$Res> {
  _$VideoSourceCopyWithImpl(this._self, this._then);

  final VideoSource _self;
  final $Res Function(VideoSource) _then;

/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = freezed,Object? position = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as CameraPosition,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoSource].
extension VideoSourcePatterns on VideoSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoSource value)  $default,){
final _that = this;
switch (_that) {
case _VideoSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoSource value)?  $default,){
final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? name,  CameraPosition position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
return $default(_that.id,_that.name,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? name,  CameraPosition position)  $default,) {final _that = this;
switch (_that) {
case _VideoSource():
return $default(_that.id,_that.name,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? name,  CameraPosition position)?  $default,) {final _that = this;
switch (_that) {
case _VideoSource() when $default != null:
return $default(_that.id,_that.name,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoSource with DiagnosticableTreeMixin implements VideoSource {
  const _VideoSource({required this.id, this.name, this.position = CameraPosition.unspecified});
  factory _VideoSource.fromJson(Map<String, dynamic> json) => _$VideoSourceFromJson(json);

/// Unique identifier of the video source.
@override final  String id;
/// Optional display name of the video source.
@override final  String? name;
/// Camera position used by this video source.
///
/// Defaults to [CameraPosition.unspecified] when not explicitly set.
@override@JsonKey() final  CameraPosition position;

/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoSourceCopyWith<_VideoSource> get copyWith => __$VideoSourceCopyWithImpl<_VideoSource>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoSourceToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'VideoSource'))
    ..add(DiagnosticsProperty('id', id))..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('position', position));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoSource&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,position);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'VideoSource(id: $id, name: $name, position: $position)';
}


}

/// @nodoc
abstract mixin class _$VideoSourceCopyWith<$Res> implements $VideoSourceCopyWith<$Res> {
  factory _$VideoSourceCopyWith(_VideoSource value, $Res Function(_VideoSource) _then) = __$VideoSourceCopyWithImpl;
@override @useResult
$Res call({
 String id, String? name, CameraPosition position
});




}
/// @nodoc
class __$VideoSourceCopyWithImpl<$Res>
    implements _$VideoSourceCopyWith<$Res> {
  __$VideoSourceCopyWithImpl(this._self, this._then);

  final _VideoSource _self;
  final $Res Function(_VideoSource) _then;

/// Create a copy of VideoSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = freezed,Object? position = null,}) {
  return _then(_VideoSource(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as CameraPosition,
  ));
}


}

// dart format on
