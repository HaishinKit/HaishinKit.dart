// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_mixer_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MediaMixerOptions _$MediaMixerOptionsFromJson(Map<String, dynamic> json) =>
    _MediaMixerOptions(
      dynamicRangeMode:
          $enumDecodeNullable(
            _$DynamicRangeModeEnumMap,
            json['dynamicRangeMode'],
          ) ??
          DynamicRangeMode.sdr,
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
      'dynamicRangeMode': _$DynamicRangeModeEnumMap[instance.dynamicRangeMode]!,
      'captureSessionMode':
          _$CaptureSessionModeEnumMap[instance.captureSessionMode]!,
      'multiTrackAudioMixingEnabled': instance.multiTrackAudioMixingEnabled,
    };

const _$DynamicRangeModeEnumMap = {
  DynamicRangeMode.sdr: 'sdr',
  DynamicRangeMode.hlg: 'hlg',
};

const _$CaptureSessionModeEnumMap = {
  CaptureSessionMode.single: 'single',
  CaptureSessionMode.multi: 'multi',
  CaptureSessionMode.manual: 'manual',
};
