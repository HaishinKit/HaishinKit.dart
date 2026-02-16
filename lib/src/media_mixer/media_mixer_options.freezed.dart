// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'media_mixer_options.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

MediaMixerOptions _$MediaMixerOptionsFromJson(Map<String, dynamic> json) {
  return _MediaMixerOptions.fromJson(json);
}

/// @nodoc
mixin _$MediaMixerOptions {
  /// Specifies how capture sessions are managed.
  CaptureSessionMode get captureSessionMode =>
      throw _privateConstructorUsedError;

  /// Enables mixing multiple audio tracks independently when set to true. Defaults to false.
  bool get multiTrackAudioMixingEnabled => throw _privateConstructorUsedError;

  /// Serializes this MediaMixerOptions to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MediaMixerOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MediaMixerOptionsCopyWith<MediaMixerOptions> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MediaMixerOptionsCopyWith<$Res> {
  factory $MediaMixerOptionsCopyWith(
          MediaMixerOptions value, $Res Function(MediaMixerOptions) then) =
      _$MediaMixerOptionsCopyWithImpl<$Res, MediaMixerOptions>;
  @useResult
  $Res call(
      {CaptureSessionMode captureSessionMode,
      bool multiTrackAudioMixingEnabled});
}

/// @nodoc
class _$MediaMixerOptionsCopyWithImpl<$Res, $Val extends MediaMixerOptions>
    implements $MediaMixerOptionsCopyWith<$Res> {
  _$MediaMixerOptionsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MediaMixerOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? captureSessionMode = null,
    Object? multiTrackAudioMixingEnabled = null,
  }) {
    return _then(_value.copyWith(
      captureSessionMode: null == captureSessionMode
          ? _value.captureSessionMode
          : captureSessionMode // ignore: cast_nullable_to_non_nullable
              as CaptureSessionMode,
      multiTrackAudioMixingEnabled: null == multiTrackAudioMixingEnabled
          ? _value.multiTrackAudioMixingEnabled
          : multiTrackAudioMixingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MediaMixerOptionsImplCopyWith<$Res>
    implements $MediaMixerOptionsCopyWith<$Res> {
  factory _$$MediaMixerOptionsImplCopyWith(_$MediaMixerOptionsImpl value,
          $Res Function(_$MediaMixerOptionsImpl) then) =
      __$$MediaMixerOptionsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {CaptureSessionMode captureSessionMode,
      bool multiTrackAudioMixingEnabled});
}

/// @nodoc
class __$$MediaMixerOptionsImplCopyWithImpl<$Res>
    extends _$MediaMixerOptionsCopyWithImpl<$Res, _$MediaMixerOptionsImpl>
    implements _$$MediaMixerOptionsImplCopyWith<$Res> {
  __$$MediaMixerOptionsImplCopyWithImpl(_$MediaMixerOptionsImpl _value,
      $Res Function(_$MediaMixerOptionsImpl) _then)
      : super(_value, _then);

  /// Create a copy of MediaMixerOptions
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? captureSessionMode = null,
    Object? multiTrackAudioMixingEnabled = null,
  }) {
    return _then(_$MediaMixerOptionsImpl(
      captureSessionMode: null == captureSessionMode
          ? _value.captureSessionMode
          : captureSessionMode // ignore: cast_nullable_to_non_nullable
              as CaptureSessionMode,
      multiTrackAudioMixingEnabled: null == multiTrackAudioMixingEnabled
          ? _value.multiTrackAudioMixingEnabled
          : multiTrackAudioMixingEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MediaMixerOptionsImpl implements _MediaMixerOptions {
  const _$MediaMixerOptionsImpl(
      {this.captureSessionMode = CaptureSessionMode.single,
      this.multiTrackAudioMixingEnabled = false});

  factory _$MediaMixerOptionsImpl.fromJson(Map<String, dynamic> json) =>
      _$$MediaMixerOptionsImplFromJson(json);

  /// Specifies how capture sessions are managed.
  @override
  @JsonKey()
  final CaptureSessionMode captureSessionMode;

  /// Enables mixing multiple audio tracks independently when set to true. Defaults to false.
  @override
  @JsonKey()
  final bool multiTrackAudioMixingEnabled;

  @override
  String toString() {
    return 'MediaMixerOptions(captureSessionMode: $captureSessionMode, multiTrackAudioMixingEnabled: $multiTrackAudioMixingEnabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MediaMixerOptionsImpl &&
            (identical(other.captureSessionMode, captureSessionMode) ||
                other.captureSessionMode == captureSessionMode) &&
            (identical(other.multiTrackAudioMixingEnabled,
                    multiTrackAudioMixingEnabled) ||
                other.multiTrackAudioMixingEnabled ==
                    multiTrackAudioMixingEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, captureSessionMode, multiTrackAudioMixingEnabled);

  /// Create a copy of MediaMixerOptions
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MediaMixerOptionsImplCopyWith<_$MediaMixerOptionsImpl> get copyWith =>
      __$$MediaMixerOptionsImplCopyWithImpl<_$MediaMixerOptionsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MediaMixerOptionsImplToJson(
      this,
    );
  }
}

abstract class _MediaMixerOptions implements MediaMixerOptions {
  const factory _MediaMixerOptions(
      {final CaptureSessionMode captureSessionMode,
      final bool multiTrackAudioMixingEnabled}) = _$MediaMixerOptionsImpl;

  factory _MediaMixerOptions.fromJson(Map<String, dynamic> json) =
      _$MediaMixerOptionsImpl.fromJson;

  /// Specifies how capture sessions are managed.
  @override
  CaptureSessionMode get captureSessionMode;

  /// Enables mixing multiple audio tracks independently when set to true. Defaults to false.
  @override
  bool get multiTrackAudioMixingEnabled;

  /// Create a copy of MediaMixerOptions
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MediaMixerOptionsImplCopyWith<_$MediaMixerOptionsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
