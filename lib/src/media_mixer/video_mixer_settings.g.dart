// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_mixer_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoMixerSettingsImpl _$$VideoMixerSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$VideoMixerSettingsImpl(
      mode: $enumDecodeNullable(_$VideoRenderingModeEnumMap, json['mode'],
              unknownValue: VideoRenderingMode.offscreen) ??
          VideoRenderingMode.offscreen,
      isMuted: json['isMuted'] as bool? ?? false,
      mainTrack: (json['mainTrack'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$VideoMixerSettingsImplToJson(
        _$VideoMixerSettingsImpl instance) =>
    <String, dynamic>{
      'mode': _$VideoRenderingModeEnumMap[instance.mode]!,
      'isMuted': instance.isMuted,
      'mainTrack': instance.mainTrack,
    };

const _$VideoRenderingModeEnumMap = {
  VideoRenderingMode.passthrough: 'passthrough',
  VideoRenderingMode.offscreen: 'offscreen',
};
