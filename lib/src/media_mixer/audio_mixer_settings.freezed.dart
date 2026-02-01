// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'audio_mixer_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AudioMixerSettings _$AudioMixerSettingsFromJson(Map<String, dynamic> json) {
  return _AudioMixerSettings.fromJson(json);
}

/// @nodoc
mixin _$AudioMixerSettings {
  int get channels => throw _privateConstructorUsedError;

  bool get isMuted => throw _privateConstructorUsedError;

  int get mainTrack => throw _privateConstructorUsedError;

  int get maximumNumberOfChannels => throw _privateConstructorUsedError;

  double get sampleRate => throw _privateConstructorUsedError;

  /// Serializes this AudioMixerSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AudioMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AudioMixerSettingsCopyWith<AudioMixerSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AudioMixerSettingsCopyWith<$Res> {
  factory $AudioMixerSettingsCopyWith(
          AudioMixerSettings value, $Res Function(AudioMixerSettings) then) =
      _$AudioMixerSettingsCopyWithImpl<$Res, AudioMixerSettings>;

  @useResult
  $Res call(
      {int channels,
      bool isMuted,
      int mainTrack,
      int maximumNumberOfChannels,
      double sampleRate});
}

/// @nodoc
class _$AudioMixerSettingsCopyWithImpl<$Res, $Val extends AudioMixerSettings>
    implements $AudioMixerSettingsCopyWith<$Res> {
  _$AudioMixerSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AudioMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? isMuted = null,
    Object? mainTrack = null,
    Object? maximumNumberOfChannels = null,
    Object? sampleRate = null,
  }) {
    return _then(_value.copyWith(
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as int,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      mainTrack: null == mainTrack
          ? _value.mainTrack
          : mainTrack // ignore: cast_nullable_to_non_nullable
              as int,
      maximumNumberOfChannels: null == maximumNumberOfChannels
          ? _value.maximumNumberOfChannels
          : maximumNumberOfChannels // ignore: cast_nullable_to_non_nullable
              as int,
      sampleRate: null == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AudioMixerSettingsImplCopyWith<$Res>
    implements $AudioMixerSettingsCopyWith<$Res> {
  factory _$$AudioMixerSettingsImplCopyWith(_$AudioMixerSettingsImpl value,
          $Res Function(_$AudioMixerSettingsImpl) then) =
      __$$AudioMixerSettingsImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call(
      {int channels,
      bool isMuted,
      int mainTrack,
      int maximumNumberOfChannels,
      double sampleRate});
}

/// @nodoc
class __$$AudioMixerSettingsImplCopyWithImpl<$Res>
    extends _$AudioMixerSettingsCopyWithImpl<$Res, _$AudioMixerSettingsImpl>
    implements _$$AudioMixerSettingsImplCopyWith<$Res> {
  __$$AudioMixerSettingsImplCopyWithImpl(_$AudioMixerSettingsImpl _value,
      $Res Function(_$AudioMixerSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AudioMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? channels = null,
    Object? isMuted = null,
    Object? mainTrack = null,
    Object? maximumNumberOfChannels = null,
    Object? sampleRate = null,
  }) {
    return _then(_$AudioMixerSettingsImpl(
      channels: null == channels
          ? _value.channels
          : channels // ignore: cast_nullable_to_non_nullable
              as int,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      mainTrack: null == mainTrack
          ? _value.mainTrack
          : mainTrack // ignore: cast_nullable_to_non_nullable
              as int,
      maximumNumberOfChannels: null == maximumNumberOfChannels
          ? _value.maximumNumberOfChannels
          : maximumNumberOfChannels // ignore: cast_nullable_to_non_nullable
              as int,
      sampleRate: null == sampleRate
          ? _value.sampleRate
          : sampleRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AudioMixerSettingsImpl
    with DiagnosticableTreeMixin
    implements _AudioMixerSettings {
  const _$AudioMixerSettingsImpl(
      {this.channels = 0,
      this.isMuted = false,
      this.mainTrack = 0,
      this.maximumNumberOfChannels = 2,
      this.sampleRate = 0.0});

  factory _$AudioMixerSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AudioMixerSettingsImplFromJson(json);

  @override
  @JsonKey()
  final int channels;
  @override
  @JsonKey()
  final bool isMuted;
  @override
  @JsonKey()
  final int mainTrack;
  @override
  @JsonKey()
  final int maximumNumberOfChannels;
  @override
  @JsonKey()
  final double sampleRate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'AudioMixerSettings(channels: $channels, isMuted: $isMuted, mainTrack: $mainTrack, maximumNumberOfChannels: $maximumNumberOfChannels, sampleRate: $sampleRate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'AudioMixerSettings'))
      ..add(DiagnosticsProperty('channels', channels))
      ..add(DiagnosticsProperty('isMuted', isMuted))
      ..add(DiagnosticsProperty('mainTrack', mainTrack))
      ..add(DiagnosticsProperty(
          'maximumNumberOfChannels', maximumNumberOfChannels))
      ..add(DiagnosticsProperty('sampleRate', sampleRate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AudioMixerSettingsImpl &&
            (identical(other.channels, channels) ||
                other.channels == channels) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.mainTrack, mainTrack) ||
                other.mainTrack == mainTrack) &&
            (identical(
                    other.maximumNumberOfChannels, maximumNumberOfChannels) ||
                other.maximumNumberOfChannels == maximumNumberOfChannels) &&
            (identical(other.sampleRate, sampleRate) ||
                other.sampleRate == sampleRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, channels, isMuted, mainTrack,
      maximumNumberOfChannels, sampleRate);

  /// Create a copy of AudioMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AudioMixerSettingsImplCopyWith<_$AudioMixerSettingsImpl> get copyWith =>
      __$$AudioMixerSettingsImplCopyWithImpl<_$AudioMixerSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AudioMixerSettingsImplToJson(
      this,
    );
  }
}

abstract class _AudioMixerSettings implements AudioMixerSettings {
  const factory _AudioMixerSettings(
      {final int channels,
      final bool isMuted,
      final int mainTrack,
      final int maximumNumberOfChannels,
      final double sampleRate}) = _$AudioMixerSettingsImpl;

  factory _AudioMixerSettings.fromJson(Map<String, dynamic> json) =
      _$AudioMixerSettingsImpl.fromJson;

  @override
  int get channels;

  @override
  bool get isMuted;

  @override
  int get mainTrack;

  @override
  int get maximumNumberOfChannels;

  @override
  double get sampleRate;

  /// Create a copy of AudioMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AudioMixerSettingsImplCopyWith<_$AudioMixerSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
