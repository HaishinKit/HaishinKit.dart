// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_mixer_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MediaMixerOptions {

/// Specifies how capture sessions are managed. iOS only.
 CaptureSessionMode get captureSessionMode;/// Enables mixing multiple audio tracks independently when set to true. Defaults to false. iOS Only.
 bool get multiTrackAudioMixingEnabled;
/// Create a copy of MediaMixerOptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MediaMixerOptionsCopyWith<MediaMixerOptions> get copyWith => _$MediaMixerOptionsCopyWithImpl<MediaMixerOptions>(this as MediaMixerOptions, _$identity);

  /// Serializes this MediaMixerOptions to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MediaMixerOptions&&(identical(other.captureSessionMode, captureSessionMode) || other.captureSessionMode == captureSessionMode)&&(identical(other.multiTrackAudioMixingEnabled, multiTrackAudioMixingEnabled) || other.multiTrackAudioMixingEnabled == multiTrackAudioMixingEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,captureSessionMode,multiTrackAudioMixingEnabled);

@override
String toString() {
  return 'MediaMixerOptions(captureSessionMode: $captureSessionMode, multiTrackAudioMixingEnabled: $multiTrackAudioMixingEnabled)';
}


}

/// @nodoc
abstract mixin class $MediaMixerOptionsCopyWith<$Res>  {
  factory $MediaMixerOptionsCopyWith(MediaMixerOptions value, $Res Function(MediaMixerOptions) _then) = _$MediaMixerOptionsCopyWithImpl;
@useResult
$Res call({
 CaptureSessionMode captureSessionMode, bool multiTrackAudioMixingEnabled
});




}
/// @nodoc
class _$MediaMixerOptionsCopyWithImpl<$Res>
    implements $MediaMixerOptionsCopyWith<$Res> {
  _$MediaMixerOptionsCopyWithImpl(this._self, this._then);

  final MediaMixerOptions _self;
  final $Res Function(MediaMixerOptions) _then;

/// Create a copy of MediaMixerOptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? captureSessionMode = null,Object? multiTrackAudioMixingEnabled = null,}) {
  return _then(_self.copyWith(
captureSessionMode: null == captureSessionMode ? _self.captureSessionMode : captureSessionMode // ignore: cast_nullable_to_non_nullable
as CaptureSessionMode,multiTrackAudioMixingEnabled: null == multiTrackAudioMixingEnabled ? _self.multiTrackAudioMixingEnabled : multiTrackAudioMixingEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [MediaMixerOptions].
extension MediaMixerOptionsPatterns on MediaMixerOptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MediaMixerOptions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MediaMixerOptions() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MediaMixerOptions value)  $default,){
final _that = this;
switch (_that) {
case _MediaMixerOptions():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MediaMixerOptions value)?  $default,){
final _that = this;
switch (_that) {
case _MediaMixerOptions() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CaptureSessionMode captureSessionMode,  bool multiTrackAudioMixingEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MediaMixerOptions() when $default != null:
return $default(_that.captureSessionMode,_that.multiTrackAudioMixingEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CaptureSessionMode captureSessionMode,  bool multiTrackAudioMixingEnabled)  $default,) {final _that = this;
switch (_that) {
case _MediaMixerOptions():
return $default(_that.captureSessionMode,_that.multiTrackAudioMixingEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CaptureSessionMode captureSessionMode,  bool multiTrackAudioMixingEnabled)?  $default,) {final _that = this;
switch (_that) {
case _MediaMixerOptions() when $default != null:
return $default(_that.captureSessionMode,_that.multiTrackAudioMixingEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MediaMixerOptions implements MediaMixerOptions {
  const _MediaMixerOptions({this.captureSessionMode = CaptureSessionMode.single, this.multiTrackAudioMixingEnabled = false});
  factory _MediaMixerOptions.fromJson(Map<String, dynamic> json) => _$MediaMixerOptionsFromJson(json);

/// Specifies how capture sessions are managed. iOS only.
@override@JsonKey() final  CaptureSessionMode captureSessionMode;
/// Enables mixing multiple audio tracks independently when set to true. Defaults to false. iOS Only.
@override@JsonKey() final  bool multiTrackAudioMixingEnabled;

/// Create a copy of MediaMixerOptions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MediaMixerOptionsCopyWith<_MediaMixerOptions> get copyWith => __$MediaMixerOptionsCopyWithImpl<_MediaMixerOptions>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MediaMixerOptionsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MediaMixerOptions&&(identical(other.captureSessionMode, captureSessionMode) || other.captureSessionMode == captureSessionMode)&&(identical(other.multiTrackAudioMixingEnabled, multiTrackAudioMixingEnabled) || other.multiTrackAudioMixingEnabled == multiTrackAudioMixingEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,captureSessionMode,multiTrackAudioMixingEnabled);

@override
String toString() {
  return 'MediaMixerOptions(captureSessionMode: $captureSessionMode, multiTrackAudioMixingEnabled: $multiTrackAudioMixingEnabled)';
}


}

/// @nodoc
abstract mixin class _$MediaMixerOptionsCopyWith<$Res> implements $MediaMixerOptionsCopyWith<$Res> {
  factory _$MediaMixerOptionsCopyWith(_MediaMixerOptions value, $Res Function(_MediaMixerOptions) _then) = __$MediaMixerOptionsCopyWithImpl;
@override @useResult
$Res call({
 CaptureSessionMode captureSessionMode, bool multiTrackAudioMixingEnabled
});




}
/// @nodoc
class __$MediaMixerOptionsCopyWithImpl<$Res>
    implements _$MediaMixerOptionsCopyWith<$Res> {
  __$MediaMixerOptionsCopyWithImpl(this._self, this._then);

  final _MediaMixerOptions _self;
  final $Res Function(_MediaMixerOptions) _then;

/// Create a copy of MediaMixerOptions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? captureSessionMode = null,Object? multiTrackAudioMixingEnabled = null,}) {
  return _then(_MediaMixerOptions(
captureSessionMode: null == captureSessionMode ? _self.captureSessionMode : captureSessionMode // ignore: cast_nullable_to_non_nullable
as CaptureSessionMode,multiTrackAudioMixingEnabled: null == multiTrackAudioMixingEnabled ? _self.multiTrackAudioMixingEnabled : multiTrackAudioMixingEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
