// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_mixer_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AudioMixerSettingsImpl _$$AudioMixerSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$AudioMixerSettingsImpl(
      channels: (json['channels'] as num?)?.toInt() ?? 0,
      isMuted: json['isMuted'] as bool? ?? false,
      mainTrack: (json['mainTrack'] as num?)?.toInt() ?? 0,
      maximumNumberOfChannels:
          (json['maximumNumberOfChannels'] as num?)?.toInt() ?? 2,
      sampleRate: (json['sampleRate'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$$AudioMixerSettingsImplToJson(
        _$AudioMixerSettingsImpl instance) =>
    <String, dynamic>{
      'channels': instance.channels,
      'isMuted': instance.isMuted,
      'mainTrack': instance.mainTrack,
      'maximumNumberOfChannels': instance.maximumNumberOfChannels,
      'sampleRate': instance.sampleRate,
    };
