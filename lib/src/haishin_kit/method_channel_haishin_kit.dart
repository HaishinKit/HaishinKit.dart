import 'dart:convert';

import 'package:flutter/services.dart';

import '../media_mixer/video_source.dart';
import '../stream_session/stream_session_mode.dart';
import 'platform_interface_haishin_kit.dart';

/// The method channel implementation of [HaishinKitPlatformInterface]
class MethodChannelHaishinKit extends HaishinKitPlatformInterface {
  static const MethodChannel channel = MethodChannel('com.haishinkit');

  @override
  Future<int?> newMediaMixer() async {
    return await channel.invokeMethod<int?>('newMediaMixer');
  }

  @override
  Future<int?> newSession(String url, StreamSessionMode mode) async {
    return await channel
        .invokeMethod<int?>('newSession', {"url": url, "mode": mode.name});
  }

  @override
  Future<int?> newScreen(int? mixer) async {
    return await channel.invokeMethod("newScreen", {"mixer": mixer});
  }

  @override
  Future<List<VideoSource>> get videoSources async {
    final String? result =
        await channel.invokeMethod<String>('getVideoSources');
    if (result == null) {
      return [];
    }
    final list = jsonDecode(result) as List? ?? [];
    return list
        .map((e) => VideoSource.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
