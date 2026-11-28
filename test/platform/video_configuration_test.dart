import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/src/haishin_kit/method_channel_haishin_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(
    () => messenger.setMockMethodCallHandler(
      MethodChannelHaishinKit.channel,
      null,
    ),
  );

  test(
    'screen resizes reach native code in order even when a reply is delayed',
    () async {
      final firstReply = Completer<void>();
      final sizes = <Map<String, dynamic>>[];
      messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, (
        call,
      ) async {
        if (call.method == 'newMediaMixer') return 1;
        if (call.method == 'newScreen') return 2;
        if (call.method == 'Screen#setSize') {
          sizes.add(
            jsonDecode((call.arguments as Map)['value'] as String)
                as Map<String, dynamic>,
          );
          if (sizes.length == 1) await firstReply.future;
        }
        return null;
      });
      final mixer = await MediaMixer.create();
      final first = mixer.screen!.resize(
        const ScreenObjectSize(width: 720, height: 1280),
      );
      final second = mixer.screen!.resize(
        const ScreenObjectSize(width: 1280, height: 720),
      );
      await pumpEventQueue();
      expect(sizes.map((size) => size['width']), [720]);
      firstReply.complete();
      await Future.wait([first, second]);
      expect(sizes.map((size) => size['width']), [720, 1280]);
      await mixer.dispose();
    },
  );

  test(
    'video settings can be awaited before connecting and retain synchronous getter behavior',
    () async {
      final applied = Completer<void>();
      var connected = false;
      messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, (
        call,
      ) async {
        if (call.method == 'newSession') return 3;
        if (call.method == 'StreamSession#setVideoSettings') {
          await applied.future;
        }
        if (call.method == 'StreamSession#connect') connected = true;
        return null;
      });
      final session = await StreamSession.create(
        'rtmp://example.com/live/test',
        StreamSessionMode.publish,
      );
      const settings = VideoCodecSettings(width: 1280, height: 720);
      final configured = session.setVideoSettings(settings);
      expect(session.videoSettings, settings);
      final start = () async {
        await configured;
        await session.connect();
      }();
      await pumpEventQueue();
      expect(connected, isFalse);
      applied.complete();
      await start;
      expect(connected, isTrue);
      await session.dispose();
    },
  );
}
