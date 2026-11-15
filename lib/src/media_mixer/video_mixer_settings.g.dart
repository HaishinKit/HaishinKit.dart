// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_mixer_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VideoMixerSettings _$VideoMixerSettingsFromJson(Map<String, dynamic> json) =>
    _VideoMixerSettings(
      mode:
          $enumDecodeNullable(
            _$VideoRenderingModeEnumMap,
            json['mode'],
            unknownValue: VideoRenderingMode.offscreen,
          ) ??
          VideoRenderingMode.offscreen,
      isMuted: json['isMuted'] as bool? ?? false,
      mainTrack: (json['mainTrack'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$VideoMixerSettingsToJson(_VideoMixerSettings instance) =>
    <String, dynamic>{
      'mode': _$VideoRenderingModeEnumMap[instance.mode]!,
      'isMuted': instance.isMuted,
      'mainTrack': instance.mainTrack,
    };

const _$VideoRenderingModeEnumMap = {
  VideoRenderingMode.passthrough: 'passthrough',
  VideoRenderingMode.offscreen: 'offscreen',
};
