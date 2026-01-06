import 'dart:convert';

import 'package:flutter/services.dart';
import 'stream_session_mode.dart';
import 'video_source.dart';
import 'haishin_kit_platform_interface.dart';

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
  Future<List<VideoSource>> get videoSources async {
    final String? result =
        await channel.invokeMethod<String>('getVideoSources');
    print(result);
    if (result == null) {
      return [];
    }
    final list = jsonDecode(result) as List? ?? [];
    return list
        .map((e) => VideoSource.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
