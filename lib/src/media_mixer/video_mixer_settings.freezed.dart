// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_mixer_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VideoMixerSettings implements DiagnosticableTreeMixin {

/// Specifies how video frames are rendered.
///
/// If the value is missing or an unknown enum value is received from JSON,
/// [VideoRenderingMode.offscreen] will be used as the default.
// Freezed forwards this annotation to the generated field.
@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen) VideoRenderingMode get mode;/// Whether the video output is muted.
///
/// When set to `true`, video frames are not rendered or mixed.
 bool get isMuted;/// Index of the main video track.
///
/// This value is typically used when multiple video tracks are available
/// and one of them should be treated as the primary source.
 int get mainTrack;
/// Create a copy of VideoMixerSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VideoMixerSettingsCopyWith<VideoMixerSettings> get copyWith => _$VideoMixerSettingsCopyWithImpl<VideoMixerSettings>(this as VideoMixerSettings, _$identity);

  /// Serializes this VideoMixerSettings to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'VideoMixerSettings'))
    ..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('isMuted', isMuted))..add(DiagnosticsProperty('mainTrack', mainTrack));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VideoMixerSettings&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.mainTrack, mainTrack) || other.mainTrack == mainTrack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,isMuted,mainTrack);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'VideoMixerSettings(mode: $mode, isMuted: $isMuted, mainTrack: $mainTrack)';
}


}

/// @nodoc
abstract mixin class $VideoMixerSettingsCopyWith<$Res>  {
  factory $VideoMixerSettingsCopyWith(VideoMixerSettings value, $Res Function(VideoMixerSettings) _then) = _$VideoMixerSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen) VideoRenderingMode mode, bool isMuted, int mainTrack
});




}
/// @nodoc
class _$VideoMixerSettingsCopyWithImpl<$Res>
    implements $VideoMixerSettingsCopyWith<$Res> {
  _$VideoMixerSettingsCopyWithImpl(this._self, this._then);

  final VideoMixerSettings _self;
  final $Res Function(VideoMixerSettings) _then;

/// Create a copy of VideoMixerSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mode = null,Object? isMuted = null,Object? mainTrack = null,}) {
  return _then(_self.copyWith(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VideoRenderingMode,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,mainTrack: null == mainTrack ? _self.mainTrack : mainTrack // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VideoMixerSettings].
extension VideoMixerSettingsPatterns on VideoMixerSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VideoMixerSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VideoMixerSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VideoMixerSettings value)  $default,){
final _that = this;
switch (_that) {
case _VideoMixerSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VideoMixerSettings value)?  $default,){
final _that = this;
switch (_that) {
case _VideoMixerSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen)  VideoRenderingMode mode,  bool isMuted,  int mainTrack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VideoMixerSettings() when $default != null:
return $default(_that.mode,_that.isMuted,_that.mainTrack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen)  VideoRenderingMode mode,  bool isMuted,  int mainTrack)  $default,) {final _that = this;
switch (_that) {
case _VideoMixerSettings():
return $default(_that.mode,_that.isMuted,_that.mainTrack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen)  VideoRenderingMode mode,  bool isMuted,  int mainTrack)?  $default,) {final _that = this;
switch (_that) {
case _VideoMixerSettings() when $default != null:
return $default(_that.mode,_that.isMuted,_that.mainTrack);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VideoMixerSettings with DiagnosticableTreeMixin implements VideoMixerSettings {
  const _VideoMixerSettings({@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen) this.mode = VideoRenderingMode.offscreen, this.isMuted = false, this.mainTrack = 0});
  factory _VideoMixerSettings.fromJson(Map<String, dynamic> json) => _$VideoMixerSettingsFromJson(json);

/// Specifies how video frames are rendered.
///
/// If the value is missing or an unknown enum value is received from JSON,
/// [VideoRenderingMode.offscreen] will be used as the default.
// Freezed forwards this annotation to the generated field.
@override@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen) final  VideoRenderingMode mode;
/// Whether the video output is muted.
///
/// When set to `true`, video frames are not rendered or mixed.
@override@JsonKey() final  bool isMuted;
/// Index of the main video track.
///
/// This value is typically used when multiple video tracks are available
/// and one of them should be treated as the primary source.
@override@JsonKey() final  int mainTrack;

/// Create a copy of VideoMixerSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VideoMixerSettingsCopyWith<_VideoMixerSettings> get copyWith => __$VideoMixerSettingsCopyWithImpl<_VideoMixerSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VideoMixerSettingsToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'VideoMixerSettings'))
    ..add(DiagnosticsProperty('mode', mode))..add(DiagnosticsProperty('isMuted', isMuted))..add(DiagnosticsProperty('mainTrack', mainTrack));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VideoMixerSettings&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.mainTrack, mainTrack) || other.mainTrack == mainTrack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mode,isMuted,mainTrack);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'VideoMixerSettings(mode: $mode, isMuted: $isMuted, mainTrack: $mainTrack)';
}


}

/// @nodoc
abstract mixin class _$VideoMixerSettingsCopyWith<$Res> implements $VideoMixerSettingsCopyWith<$Res> {
  factory _$VideoMixerSettingsCopyWith(_VideoMixerSettings value, $Res Function(_VideoMixerSettings) _then) = __$VideoMixerSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: VideoRenderingMode.offscreen, unknownEnumValue: VideoRenderingMode.offscreen) VideoRenderingMode mode, bool isMuted, int mainTrack
});




}
/// @nodoc
class __$VideoMixerSettingsCopyWithImpl<$Res>
    implements _$VideoMixerSettingsCopyWith<$Res> {
  __$VideoMixerSettingsCopyWithImpl(this._self, this._then);

  final _VideoMixerSettings _self;
  final $Res Function(_VideoMixerSettings) _then;

/// Create a copy of VideoMixerSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mode = null,Object? isMuted = null,Object? mainTrack = null,}) {
  return _then(_VideoMixerSettings(
mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as VideoRenderingMode,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,mainTrack: null == mainTrack ? _self.mainTrack : mainTrack // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
