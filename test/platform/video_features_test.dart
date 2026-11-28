import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/src/haishin_kit/method_channel_haishin_kit.dart';

class _LegacyPlatform extends HaishinKitPlatformInterface {
  int creations = 0;

  @override
  Future<int?> newSession(String url, StreamSessionMode mode) async {
    creations += 1;
    return 7;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late HaishinKitPlatformInterface previous;
  final calls = <MethodCall>[];

  setUp(() {
    previous = HaishinKitPlatformInterface.instance;
    HaishinKitPlatformInterface.instance = MethodChannelHaishinKit();
    calls.clear();
    messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, (
      call,
    ) async {
      calls.add(call);
      if (call.method == 'newSession') return 3;
      if (call.method == 'newMediaMixer') return 1;
      if (call.method == 'newScreen') return 2;
      if (call.method == 'getSupportedVideoCodecs') return ['hevc', 'av1'];
      return null;
    });
  });
  tearDown(() {
    HaishinKitPlatformInterface.instance = previous;
    messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, null);
    messenger.setMockMethodCallHandler(SystemChannels.platform_views, null);
  });

  test('range is forwarded to both capture and playback creation', () async {
    final mixer = await MediaMixer.create(
      options: const MediaMixerOptions(dynamicRangeMode: DynamicRangeMode.hlg),
    );
    final session = await StreamSession.create(
      'rtmp://example.com/live/test',
      StreamSessionMode.playback,
      dynamicRangeMode: DynamicRangeMode.hlg,
    );
    final mixerCall = calls.firstWhere(
      (call) => call.method == 'newMediaMixer',
    );
    expect(
      jsonDecode((mixerCall.arguments as Map)['value'] as String),
      containsPair('dynamicRangeMode', 'hlg'),
    );
    final sessionCall = calls.firstWhere((call) => call.method == 'newSession');
    expect(sessionCall.arguments, containsPair('dynamicRangeMode', 'hlg'));
    expect(session.dynamicRangeMode, DynamicRangeMode.hlg);
    await session.dispose();
    await mixer.dispose();
  });

  test(
    'codec-only selection leaves unrelated native settings untouched',
    () async {
      final session = await StreamSession.create(
        'rtmp://example.com/live/test',
        StreamSessionMode.publish,
      );
      await session.setVideoCodec(VideoCodec.vp9);
      final update = calls.singleWhere(
        (call) => call.method == 'StreamSession#setVideoSettings',
      );
      expect((update.arguments as Map)['settings'], {'codec': 'vp9'});
      expect(session.videoSettings.codec, VideoCodec.vp9);
      await session.dispose();
    },
  );

  test(
    'capability query carries the selected range and decodes codec names',
    () async {
      final values = await HaishinKitPlatformInterface.instance
          .supportedVideoCodecs(dynamicRangeMode: DynamicRangeMode.hlg);
      expect(values, [VideoCodec.hevc, VideoCodec.av1]);
      expect(calls.single.arguments, {'dynamicRangeMode': 'hlg'});
    },
  );

  test(
    'legacy platform implementations retain SDR and reject unsupported HLG',
    () async {
      final legacy = _LegacyPlatform();
      HaishinKitPlatformInterface.instance = legacy;
      final session = await StreamSession.create(
        'rtmp://example.com/live/test',
        StreamSessionMode.publish,
      );
      expect(session.memory, 7);
      expect(legacy.creations, 1);
      await expectLater(
        StreamSession.create(
          'rtmp://example.com/live/test',
          StreamSessionMode.publish,
          dynamicRangeMode: DynamicRangeMode.hlg,
        ),
        throwsUnsupportedError,
      );
      await session.dispose();
    },
  );

  testWidgets(
    'Android HLG uses hybrid composition and no Flutter video texture',
    (tester) async {
      final platformCalls = <MethodCall>[];
      messenger.setMockMethodCallHandler(SystemChannels.platform_views, (
        call,
      ) async {
        platformCalls.add(call);
        return null;
      });
      final session = await StreamSession.create(
        'rtmp://example.com/live/test',
        StreamSessionMode.playback,
        dynamicRangeMode: DynamicRangeMode.hlg,
      );
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: StreamSessionView(session),
        ),
      );
      await tester.pumpAndSettle();
      final creation = platformCalls.singleWhere(
        (call) => call.method == 'create',
      );
      expect(creation.arguments, containsPair('hybrid', true));
      expect(
        creation.arguments,
        containsPair('viewType', 'com.haishinkit.hdr'),
      );
      expect(
        calls.where((call) => call.method == 'StreamSession#registerTexture'),
        isEmpty,
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await session.dispose();
      expect(tester.takeException(), isNull);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.android),
  );
}
