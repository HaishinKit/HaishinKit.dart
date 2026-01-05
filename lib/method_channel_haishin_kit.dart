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
    final List<dynamic>? result =
        await channel.invokeMethod<List<dynamic>>('getVideoSources');
    if (result == null) {
      return [];
    }
    return result
        .cast<Map<dynamic, dynamic>>()
        .map((e) => VideoSource.fromMap(e.cast<String, dynamic>()))
        .toList();
  }
}
