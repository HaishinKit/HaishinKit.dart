import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/method_channel_haishin_kit.dart';
import 'package:haishin_kit/stream_session_mode.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockHaishinKitPlatform
    with MockPlatformInterfaceMixin
    implements HaishinKitPlatformInterface {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<List<VideoSource>> get videoSources => Future.value([]);

  @override
  Future<int?> newMediaMixer() {
    throw UnimplementedError();
  }

  @override
  Future<int?> newSession(String url, StreamSessionMode mode) {
    throw UnimplementedError();
  }
}

void main() {
  final HaishinKitPlatformInterface initialPlatform =
      HaishinKitPlatformInterface.instance;

  test('$MethodChannelHaishinKit is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelHaishinKit>());
  });

  test('getPlatformVersion', () async {
    MockHaishinKitPlatform fakePlatform = MockHaishinKitPlatform();
    HaishinKitPlatformInterface.instance = fakePlatform;

    // expect(await haishinKitPlugin.getPlatformVersion(), '42');
  });
}
