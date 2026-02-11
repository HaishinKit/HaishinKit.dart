// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'video_mixer_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoMixerSettings _$VideoMixerSettingsFromJson(Map<String, dynamic> json) {
  return _VideoMixerSettings.fromJson(json);
}

/// @nodoc
mixin _$VideoMixerSettings {
  /// Specifies how video frames are rendered.
  ///
  /// If the value is missing or an unknown enum value is received from JSON,
  /// [VideoRenderingMode.offscreen] will be used as the default.
  @JsonKey(
      defaultValue: VideoRenderingMode.offscreen,
      unknownEnumValue: VideoRenderingMode.offscreen)
  VideoRenderingMode get mode => throw _privateConstructorUsedError;

  /// Whether the video output is muted.
  ///
  /// When set to `true`, video frames are not rendered or mixed.
  bool get isMuted => throw _privateConstructorUsedError;

  /// Index of the main video track.
  ///
  /// This value is typically used when multiple video tracks are available
  /// and one of them should be treated as the primary source.
  int get mainTrack => throw _privateConstructorUsedError;

  /// Serializes this VideoMixerSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoMixerSettingsCopyWith<VideoMixerSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoMixerSettingsCopyWith<$Res> {
  factory $VideoMixerSettingsCopyWith(
          VideoMixerSettings value, $Res Function(VideoMixerSettings) then) =
      _$VideoMixerSettingsCopyWithImpl<$Res, VideoMixerSettings>;
  @useResult
  $Res call(
      {@JsonKey(
          defaultValue: VideoRenderingMode.offscreen,
          unknownEnumValue: VideoRenderingMode.offscreen)
      VideoRenderingMode mode,
      bool isMuted,
      int mainTrack});
}

/// @nodoc
class _$VideoMixerSettingsCopyWithImpl<$Res, $Val extends VideoMixerSettings>
    implements $VideoMixerSettingsCopyWith<$Res> {
  _$VideoMixerSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? isMuted = null,
    Object? mainTrack = null,
  }) {
    return _then(_value.copyWith(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as VideoRenderingMode,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      mainTrack: null == mainTrack
          ? _value.mainTrack
          : mainTrack // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoMixerSettingsImplCopyWith<$Res>
    implements $VideoMixerSettingsCopyWith<$Res> {
  factory _$$VideoMixerSettingsImplCopyWith(_$VideoMixerSettingsImpl value,
          $Res Function(_$VideoMixerSettingsImpl) then) =
      __$$VideoMixerSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(
          defaultValue: VideoRenderingMode.offscreen,
          unknownEnumValue: VideoRenderingMode.offscreen)
      VideoRenderingMode mode,
      bool isMuted,
      int mainTrack});
}

/// @nodoc
class __$$VideoMixerSettingsImplCopyWithImpl<$Res>
    extends _$VideoMixerSettingsCopyWithImpl<$Res, _$VideoMixerSettingsImpl>
    implements _$$VideoMixerSettingsImplCopyWith<$Res> {
  __$$VideoMixerSettingsImplCopyWithImpl(_$VideoMixerSettingsImpl _value,
      $Res Function(_$VideoMixerSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mode = null,
    Object? isMuted = null,
    Object? mainTrack = null,
  }) {
    return _then(_$VideoMixerSettingsImpl(
      mode: null == mode
          ? _value.mode
          : mode // ignore: cast_nullable_to_non_nullable
              as VideoRenderingMode,
      isMuted: null == isMuted
          ? _value.isMuted
          : isMuted // ignore: cast_nullable_to_non_nullable
              as bool,
      mainTrack: null == mainTrack
          ? _value.mainTrack
          : mainTrack // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoMixerSettingsImpl
    with DiagnosticableTreeMixin
    implements _VideoMixerSettings {
  const _$VideoMixerSettingsImpl(
      {@JsonKey(
          defaultValue: VideoRenderingMode.offscreen,
          unknownEnumValue: VideoRenderingMode.offscreen)
      this.mode = VideoRenderingMode.offscreen,
      this.isMuted = false,
      this.mainTrack = 0});

  factory _$VideoMixerSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoMixerSettingsImplFromJson(json);

  /// Specifies how video frames are rendered.
  ///
  /// If the value is missing or an unknown enum value is received from JSON,
  /// [VideoRenderingMode.offscreen] will be used as the default.
  @override
  @JsonKey(
      defaultValue: VideoRenderingMode.offscreen,
      unknownEnumValue: VideoRenderingMode.offscreen)
  final VideoRenderingMode mode;

  /// Whether the video output is muted.
  ///
  /// When set to `true`, video frames are not rendered or mixed.
  @override
  @JsonKey()
  final bool isMuted;

  /// Index of the main video track.
  ///
  /// This value is typically used when multiple video tracks are available
  /// and one of them should be treated as the primary source.
  @override
  @JsonKey()
  final int mainTrack;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'VideoMixerSettings(mode: $mode, isMuted: $isMuted, mainTrack: $mainTrack)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'VideoMixerSettings'))
      ..add(DiagnosticsProperty('mode', mode))
      ..add(DiagnosticsProperty('isMuted', isMuted))
      ..add(DiagnosticsProperty('mainTrack', mainTrack));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoMixerSettingsImpl &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.mainTrack, mainTrack) ||
                other.mainTrack == mainTrack));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, mode, isMuted, mainTrack);

  /// Create a copy of VideoMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoMixerSettingsImplCopyWith<_$VideoMixerSettingsImpl> get copyWith =>
      __$$VideoMixerSettingsImplCopyWithImpl<_$VideoMixerSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoMixerSettingsImplToJson(
      this,
    );
  }
}

abstract class _VideoMixerSettings implements VideoMixerSettings {
  const factory _VideoMixerSettings(
      {@JsonKey(
          defaultValue: VideoRenderingMode.offscreen,
          unknownEnumValue: VideoRenderingMode.offscreen)
      final VideoRenderingMode mode,
      final bool isMuted,
      final int mainTrack}) = _$VideoMixerSettingsImpl;

  factory _VideoMixerSettings.fromJson(Map<String, dynamic> json) =
      _$VideoMixerSettingsImpl.fromJson;

  /// Specifies how video frames are rendered.
  ///
  /// If the value is missing or an unknown enum value is received from JSON,
  /// [VideoRenderingMode.offscreen] will be used as the default.
  @override
  @JsonKey(
      defaultValue: VideoRenderingMode.offscreen,
      unknownEnumValue: VideoRenderingMode.offscreen)
  VideoRenderingMode get mode;

  /// Whether the video output is muted.
  ///
  /// When set to `true`, video frames are not rendered or mixed.
  @override
  bool get isMuted;

  /// Index of the main video track.
  ///
  /// This value is typically used when multiple video tracks are available
  /// and one of them should be treated as the primary source.
  @override
  int get mainTrack;

  /// Create a copy of VideoMixerSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoMixerSettingsImplCopyWith<_$VideoMixerSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
