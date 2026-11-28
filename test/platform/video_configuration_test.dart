import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
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

  test('changing video size preserves native bitrate and profile', () async {
    final native = <String, dynamic>{
      'bitrate': 640000,
      'profileLevel': 'H264_Baseline_3_2',
      'frameInterval': 2,
    };
    Map<Object?, Object?>? submitted;
    messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, (
      call,
    ) async {
      if (call.method == 'newSession') return 3;
      if (call.method == 'StreamSession#setVideoSettings') {
        submitted = (call.arguments as Map)['settings'] as Map;
        native.addAll(submitted!.cast<String, dynamic>());
      }
      return null;
    });
    final session = await StreamSession.create(
      'rtmp://example.com/live/test',
      StreamSessionMode.publish,
    );
    await session.setVideoSize(width: 1280, height: 720);
    expect(submitted, {'width': 1280, 'height': 720});
    expect(native['bitrate'], 640000);
    expect(native['profileLevel'], 'H264_Baseline_3_2');
    expect(native['frameInterval'], 2);
    expect(session.videoSettings.width, 1280);
    expect(session.videoSettings.height, 720);
    await session.dispose();
  });

  test(
    'legacy size setter reaches native code before an immediate connect',
    () async {
      final calls = <String>[];
      messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, (
        call,
      ) async {
        if (call.method == 'newMediaMixer') return 1;
        if (call.method == 'newScreen') return 2;
        if (call.method == 'newSession') return 3;
        calls.add(call.method);
        return null;
      });
      final mixer = await MediaMixer.create();
      final session = await StreamSession.create(
        'rtmp://example.com/live/test',
        StreamSessionMode.publish,
      );
      mixer.screen!.size = const ScreenObjectSize(width: 1280, height: 720);
      await session.connect();
      expect(
        calls.indexOf('Screen#setSize'),
        lessThan(calls.indexOf('StreamSession#connect')),
      );
      await session.dispose();
      await mixer.dispose();
    },
  );

  test('screen disposal drains queued resizes and rejects new ones', () async {
    final firstReply = Completer<void>();
    final calls = <String>[];
    var sizes = 0;
    messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, (
      call,
    ) async {
      if (call.method == 'newMediaMixer') return 1;
      if (call.method == 'newScreen') return 2;
      calls.add(call.method);
      if (call.method == 'Screen#setSize' && ++sizes == 1) {
        await firstReply.future;
      }
      return null;
    });
    final mixer = await MediaMixer.create();
    final screen = mixer.screen!;
    final first = screen.resize(
      const ScreenObjectSize(width: 720, height: 1280),
    );
    final second = screen.resize(
      const ScreenObjectSize(width: 1280, height: 720),
    );
    final disposal = screen.dispose();
    await pumpEventQueue();
    expect(calls.where((method) => method == 'Screen#setSize'), hasLength(1));
    expect(calls, isNot(contains('Screen#dispose')));
    expect(
      () => screen.resize(const ScreenObjectSize(width: 720, height: 1280)),
      throwsStateError,
    );
    firstReply.complete();
    await Future.wait([first, second, disposal]);
    final relevant = calls
        .where(
          (method) => method == 'Screen#setSize' || method == 'Screen#dispose',
        )
        .toList();
    expect(relevant, ['Screen#setSize', 'Screen#setSize', 'Screen#dispose']);
    await mixer.dispose();
    expect(calls.where((method) => method == 'Screen#dispose'), hasLength(1));
  });

  test('a failed resize does not prevent the next queued resize', () async {
    var attempts = 0;
    messenger.setMockMethodCallHandler(MethodChannelHaishinKit.channel, (
      call,
    ) async {
      if (call.method == 'newMediaMixer') return 1;
      if (call.method == 'newScreen') return 2;
      if (call.method == 'Screen#setSize' && ++attempts == 1) {
        throw PlatformException(code: 'RESIZE_FAILED');
      }
      return null;
    });
    final mixer = await MediaMixer.create();
    final first = mixer.screen!.resize(
      const ScreenObjectSize(width: 720, height: 1280),
    );
    final next = mixer.screen!.resize(
      const ScreenObjectSize(width: 1280, height: 720),
    );
    await expectLater(first, throwsA(isA<PlatformException>()));
    await next;
    expect(attempts, 2);
    await mixer.dispose();
  });
}
