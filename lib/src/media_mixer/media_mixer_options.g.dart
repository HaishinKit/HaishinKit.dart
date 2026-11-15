// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_mixer_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaMixerOptions _$MediaMixerOptionsFromJson(Map<String, dynamic> json) =>
    _MediaMixerOptions(
      captureSessionMode:
          $enumDecodeNullable(
            _$CaptureSessionModeEnumMap,
            json['captureSessionMode'],
          ) ??
          CaptureSessionMode.single,
      multiTrackAudioMixingEnabled:
          json['multiTrackAudioMixingEnabled'] as bool? ?? false,
    );

Map<String, dynamic> _$MediaMixerOptionsToJson(_MediaMixerOptions instance) =>
    <String, dynamic>{
      'captureSessionMode':
          _$CaptureSessionModeEnumMap[instance.captureSessionMode]!,
      'multiTrackAudioMixingEnabled': instance.multiTrackAudioMixingEnabled,
    };

const _$CaptureSessionModeEnumMap = {
  CaptureSessionMode.single: 'single',
  CaptureSessionMode.multi: 'multi',
  CaptureSessionMode.manual: 'manual',
};
