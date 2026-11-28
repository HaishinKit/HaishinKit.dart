import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:haishin_kit_example/publish_page.dart';
import 'package:haishin_kit_example/studio_theme.dart';

void main() {
  testWidgets('live output stays fixed until reconnect after rotating', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const native = MethodChannel('com.haishinkit');
    const events = MethodChannel('com.haishinkit.eventchannel/3');
    const audio = MethodChannel('com.ryanheise.audio_session');
    const permissions = MethodChannel(
      'flutter.baseflow.com/permissions/methods',
    );
    final screenSizes = <Map<String, dynamic>>[];
    final starts = <Map<String, Object?>>[];
    Map<Object?, Object?>? videoSize;
    var encoderWrites = 0;
    var mixerDisposed = false;
    Completer<void>? resizeReply = Completer<void>();
    final firstPreviewReply = resizeReply;
    void emit(String state) => ServicesBinding.instance.channelBuffers.push(
      events.name,
      const StandardMethodCodec().encodeSuccessEnvelope(state),
      (_) {},
    );
    messenger.setMockMethodCallHandler(events, (call) async => null);
    messenger.setMockMethodCallHandler(audio, (call) async => null);
    messenger.setMockMethodCallHandler(
      permissions,
      (call) async => {for (final id in call.arguments as List) id: 1},
    );
    messenger.setMockMethodCallHandler(native, (call) async {
      switch (call.method) {
        case 'getSupportedVideoCodecs':
          return ['h264'];
        case 'getVideoSources':
          return jsonEncode([
            {'id': '0', 'name': 'Back', 'position': 'back'},
          ]);
        case 'newMediaMixer':
          return 1;
        case 'newScreen':
          return 2;
        case 'newSession':
          return 3;
        case 'Screen#setSize':
          screenSizes.add(
            jsonDecode((call.arguments as Map)['value'] as String)
                as Map<String, dynamic>,
          );
          final reply = resizeReply;
          resizeReply = null;
          await reply?.future;
          return null;
        case 'Screen#getBounds':
          return <String, dynamic>{};
        case 'StreamSession#registerTexture':
        case 'StreamSession#updateTexture':
          return 1;
        case 'StreamSession#setVideoSettings':
          final settings = (call.arguments as Map)['settings'] as Map;
          if (settings.containsKey('width')) {
            encoderWrites += 1;
            videoSize = settings;
          }
          return null;
        case 'StreamSession#connect':
          starts.add({
            'canvas': Map.of(screenSizes.last),
            'encoder': Map.of(videoSize!),
          });
          emit('open');
          return null;
        case 'StreamSession#close':
          emit('closed');
          return null;
        case 'MediaMixer#dispose':
          mixerDisposed = true;
          return null;
        default:
          return null;
      }
    });
    addTearDown(() {
      for (final channel in [native, events, audio, permissions]) {
        messenger.setMockMethodCallHandler(channel, null);
      }
    });
    await tester.pumpWidget(
      MaterialApp(
        theme: studioTheme(),
        home: const Scaffold(body: PublishPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Go live'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
    expect(starts, isEmpty);
    expect(encoderWrites, 0);
    firstPreviewReply.complete();
    await tester.pumpAndSettle();
    expect(starts, [
      {
        'canvas': {'width': 720, 'height': 1280},
        'encoder': {'width': 720, 'height': 1280},
      },
    ]);
    expect(find.text('Stop stream'), findsOneWidget);
    final sizesWhileLive = screenSizes.length;
    tester.view.physicalSize = const Size(1000, 700);
    await tester.pumpAndSettle();
    expect(screenSizes.length, sizesWhileLive);
    expect(starts, hasLength(1));
    expect(encoderWrites, 1);
    expect(videoSize, {'width': 720, 'height': 1280});
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(find.text('Go live'), findsOneWidget);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(starts, [
      {
        'canvas': {'width': 720, 'height': 1280},
        'encoder': {'width': 720, 'height': 1280},
      },
      {
        'canvas': {'width': 1280, 'height': 720},
        'encoder': {'width': 1280, 'height': 720},
      },
    ]);
    expect(encoderWrites, 2);
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    final lastPreviewReply = Completer<void>();
    resizeReply = lastPreviewReply;
    tester.view.physicalSize = const Size(700, 1000);
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
    expect(mixerDisposed, isFalse);
    lastPreviewReply.complete();
    await tester.pumpAndSettle();
    expect(mixerDisposed, isTrue);
    expect(tester.takeException(), isNull);
  });
}
