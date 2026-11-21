// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_mixer_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AudioMixerSettings implements DiagnosticableTreeMixin {

 int get channels; bool get isMuted; int get mainTrack; int get maximumNumberOfChannels; double get sampleRate;
/// Create a copy of AudioMixerSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AudioMixerSettingsCopyWith<AudioMixerSettings> get copyWith => _$AudioMixerSettingsCopyWithImpl<AudioMixerSettings>(this as AudioMixerSettings, _$identity);

  /// Serializes this AudioMixerSettings to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AudioMixerSettings'))
    ..add(DiagnosticsProperty('channels', channels))..add(DiagnosticsProperty('isMuted', isMuted))..add(DiagnosticsProperty('mainTrack', mainTrack))..add(DiagnosticsProperty('maximumNumberOfChannels', maximumNumberOfChannels))..add(DiagnosticsProperty('sampleRate', sampleRate));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AudioMixerSettings&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.mainTrack, mainTrack) || other.mainTrack == mainTrack)&&(identical(other.maximumNumberOfChannels, maximumNumberOfChannels) || other.maximumNumberOfChannels == maximumNumberOfChannels)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,channels,isMuted,mainTrack,maximumNumberOfChannels,sampleRate);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AudioMixerSettings(channels: $channels, isMuted: $isMuted, mainTrack: $mainTrack, maximumNumberOfChannels: $maximumNumberOfChannels, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class $AudioMixerSettingsCopyWith<$Res>  {
  factory $AudioMixerSettingsCopyWith(AudioMixerSettings value, $Res Function(AudioMixerSettings) _then) = _$AudioMixerSettingsCopyWithImpl;
@useResult
$Res call({
 int channels, bool isMuted, int mainTrack, int maximumNumberOfChannels, double sampleRate
});




}
/// @nodoc
class _$AudioMixerSettingsCopyWithImpl<$Res>
    implements $AudioMixerSettingsCopyWith<$Res> {
  _$AudioMixerSettingsCopyWithImpl(this._self, this._then);

  final AudioMixerSettings _self;
  final $Res Function(AudioMixerSettings) _then;

/// Create a copy of AudioMixerSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? channels = null,Object? isMuted = null,Object? mainTrack = null,Object? maximumNumberOfChannels = null,Object? sampleRate = null,}) {
  return _then(_self.copyWith(
channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,mainTrack: null == mainTrack ? _self.mainTrack : mainTrack // ignore: cast_nullable_to_non_nullable
as int,maximumNumberOfChannels: null == maximumNumberOfChannels ? _self.maximumNumberOfChannels : maximumNumberOfChannels // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AudioMixerSettings].
extension AudioMixerSettingsPatterns on AudioMixerSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AudioMixerSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AudioMixerSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AudioMixerSettings value)  $default,){
final _that = this;
switch (_that) {
case _AudioMixerSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AudioMixerSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AudioMixerSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int channels,  bool isMuted,  int mainTrack,  int maximumNumberOfChannels,  double sampleRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AudioMixerSettings() when $default != null:
return $default(_that.channels,_that.isMuted,_that.mainTrack,_that.maximumNumberOfChannels,_that.sampleRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int channels,  bool isMuted,  int mainTrack,  int maximumNumberOfChannels,  double sampleRate)  $default,) {final _that = this;
switch (_that) {
case _AudioMixerSettings():
return $default(_that.channels,_that.isMuted,_that.mainTrack,_that.maximumNumberOfChannels,_that.sampleRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int channels,  bool isMuted,  int mainTrack,  int maximumNumberOfChannels,  double sampleRate)?  $default,) {final _that = this;
switch (_that) {
case _AudioMixerSettings() when $default != null:
return $default(_that.channels,_that.isMuted,_that.mainTrack,_that.maximumNumberOfChannels,_that.sampleRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AudioMixerSettings with DiagnosticableTreeMixin implements AudioMixerSettings {
  const _AudioMixerSettings({this.channels = 0, this.isMuted = false, this.mainTrack = 0, this.maximumNumberOfChannels = 2, this.sampleRate = 0.0});
  factory _AudioMixerSettings.fromJson(Map<String, dynamic> json) => _$AudioMixerSettingsFromJson(json);

@override@JsonKey() final  int channels;
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  int mainTrack;
@override@JsonKey() final  int maximumNumberOfChannels;
@override@JsonKey() final  double sampleRate;

/// Create a copy of AudioMixerSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AudioMixerSettingsCopyWith<_AudioMixerSettings> get copyWith => __$AudioMixerSettingsCopyWithImpl<_AudioMixerSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AudioMixerSettingsToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'AudioMixerSettings'))
    ..add(DiagnosticsProperty('channels', channels))..add(DiagnosticsProperty('isMuted', isMuted))..add(DiagnosticsProperty('mainTrack', mainTrack))..add(DiagnosticsProperty('maximumNumberOfChannels', maximumNumberOfChannels))..add(DiagnosticsProperty('sampleRate', sampleRate));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AudioMixerSettings&&(identical(other.channels, channels) || other.channels == channels)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.mainTrack, mainTrack) || other.mainTrack == mainTrack)&&(identical(other.maximumNumberOfChannels, maximumNumberOfChannels) || other.maximumNumberOfChannels == maximumNumberOfChannels)&&(identical(other.sampleRate, sampleRate) || other.sampleRate == sampleRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,channels,isMuted,mainTrack,maximumNumberOfChannels,sampleRate);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'AudioMixerSettings(channels: $channels, isMuted: $isMuted, mainTrack: $mainTrack, maximumNumberOfChannels: $maximumNumberOfChannels, sampleRate: $sampleRate)';
}


}

/// @nodoc
abstract mixin class _$AudioMixerSettingsCopyWith<$Res> implements $AudioMixerSettingsCopyWith<$Res> {
  factory _$AudioMixerSettingsCopyWith(_AudioMixerSettings value, $Res Function(_AudioMixerSettings) _then) = __$AudioMixerSettingsCopyWithImpl;
@override @useResult
$Res call({
 int channels, bool isMuted, int mainTrack, int maximumNumberOfChannels, double sampleRate
});




}
/// @nodoc
class __$AudioMixerSettingsCopyWithImpl<$Res>
    implements _$AudioMixerSettingsCopyWith<$Res> {
  __$AudioMixerSettingsCopyWithImpl(this._self, this._then);

  final _AudioMixerSettings _self;
  final $Res Function(_AudioMixerSettings) _then;

/// Create a copy of AudioMixerSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? channels = null,Object? isMuted = null,Object? mainTrack = null,Object? maximumNumberOfChannels = null,Object? sampleRate = null,}) {
  return _then(_AudioMixerSettings(
channels: null == channels ? _self.channels : channels // ignore: cast_nullable_to_non_nullable
as int,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,mainTrack: null == mainTrack ? _self.mainTrack : mainTrack // ignore: cast_nullable_to_non_nullable
as int,maximumNumberOfChannels: null == maximumNumberOfChannels ? _self.maximumNumberOfChannels : maximumNumberOfChannels // ignore: cast_nullable_to_non_nullable
as int,sampleRate: null == sampleRate ? _self.sampleRate : sampleRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
