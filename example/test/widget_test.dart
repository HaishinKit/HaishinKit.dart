import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit_example/main.dart';
import 'package:haishin_kit_example/preference.dart';
import 'package:haishin_kit_example/studio_theme.dart';
import 'package:haishin_kit_example/studio_widgets.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Preference previous;
  const native = MethodChannel('com.haishinkit');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  setUp(() {
    previous = Preference.shared;
    Preference.shared = Preference();
    messenger.setMockMethodCallHandler(native, (call) async {
      if (call.method == 'getSupportedVideoCodecs') {
        return (call.arguments as Map)['dynamicRangeMode'] == 'hlg'
            ? ['hevc']
            : ['h264', 'hevc'];
      }
      return null;
    });
  });

  tearDown(() {
    Preference.shared = previous;
    messenger.setMockMethodCallHandler(native, null);
  });

  testWidgets(
    'settings validate URLs and only enable RTMP stream names for RTMP',
    (tester) async {
      await tester.pumpWidget(
        const HaishinKitExampleApp(initialDestination: 2),
      );
      await tester.pumpAndSettle();
      final url = find.byKey(const ValueKey('stream-url'));
      final name = find.byKey(const ValueKey('stream-name'));
      await tester.enterText(url, 'invalid');
      await tester.pump();
      expect(find.text('Enter a supported URL with a host.'), findsOneWidget);
      await tester.enterText(url, 'https://example.com/whip?token=test');
      await tester.pump();
      expect(tester.widget<TextFormField>(name).enabled, isFalse);
      expect(
        Preference.shared.makeUrl(),
        'https://example.com/whip?token=test',
      );
      await tester.enterText(url, 'rtmps://example.com/live');
      await tester.pump();
      expect(tester.widget<TextFormField>(name).enabled, isTrue);
      await tester.enterText(name, 'camera');
      expect(Preference.shared.makeUrl(), 'rtmps://example.com/live/camera');
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpWidget(
        const HaishinKitExampleApp(initialDestination: 2),
      );
      await tester.pumpAndSettle();
      expect(find.text('rtmps://example.com/live'), findsOneWidget);
      expect(find.text('camera'), findsOneWidget);
    },
  );

  testWidgets('settings scroll with large text on a small phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 700);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('stream-name')),
      160,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide windows use a navigation rail and localized labels', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 500);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
    expect(find.text('接続先'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'navigation stays reachable in a short wide window with 2x text',
    (tester) async {
      tester.view.physicalSize = const Size(900, 375);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 2;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        const HaishinKitExampleApp(initialDestination: 2),
      );
      await tester.pumpAndSettle();
      final railSettings = find.descendant(
        of: find.byType(NavigationRail),
        matching: find.text('Settings'),
      );
      await tester.ensureVisible(railSettings);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'pending stream operations remain visible and cannot be submitted twice',
    (tester) async {
      var calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: studioTheme(),
          home: Scaffold(
            body: StudioStreamAction(
              state: StreamSessionReadyState.connecting,
              onPressed: () => calls++,
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(calls, 0);
    },
  );

  testWidgets('HDR and protocol changes keep the publishing codec valid', (
    tester,
  ) async {
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    final dropdown = find.byType(DropdownButton<VideoCodec>);
    DropdownButton<VideoCodec> field() => tester.widget(dropdown);
    await tester.ensureVisible(dropdown);
    await tester.pump();
    expect(field().items!.map((item) => item.value), [
      VideoCodec.h264,
      VideoCodec.hevc,
    ]);
    final hdr = find.byType(SwitchListTile);
    await tester.ensureVisible(hdr);
    await tester.pump();
    await tester.tap(hdr);
    await tester.pumpAndSettle();
    expect(Preference.shared.dynamicRangeMode, DynamicRangeMode.hlg);
    expect(Preference.shared.videoCodec, VideoCodec.hevc);
    expect(field().items!.map((item) => item.value), [VideoCodec.hevc]);
    final url = find.byKey(const ValueKey('stream-url'));
    await tester.scrollUntilVisible(
      url,
      -240,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pump();
    await tester.enterText(url, 'https://example.com/whip');
    await tester.pumpAndSettle();
    expect(Preference.shared.dynamicRangeMode, DynamicRangeMode.sdr);
    expect(Preference.shared.videoCodec, VideoCodec.h264);
    expect(field().items!.map((item) => item.value), [VideoCodec.h264]);
    expect(tester.widget<SwitchListTile>(hdr).onChanged, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('late HDR capability replies cannot override a new HTTP URL', (
    tester,
  ) async {
    final hdrReply = Completer<List<String>>();
    messenger.setMockMethodCallHandler(native, (call) async {
      if (call.method != 'getSupportedVideoCodecs') return null;
      if ((call.arguments as Map)['dynamicRangeMode'] == 'hlg') {
        return hdrReply.future;
      }
      return ['h264', 'hevc'];
    });
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    final hdr = find.byType(SwitchListTile);
    await tester.ensureVisible(hdr);
    await tester.pump();
    await tester.tap(hdr);
    await tester.pump();
    final url = find.byKey(const ValueKey('stream-url'));
    await tester.scrollUntilVisible(
      url,
      -240,
      scrollable: find
          .descendant(
            of: find.byType(ListView),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pump();
    await tester.enterText(url, 'https://example.com/whip');
    await tester.pumpAndSettle();
    hdrReply.complete(['hevc']);
    await tester.pumpAndSettle();
    expect(Preference.shared.dynamicRangeMode, DynamicRangeMode.sdr);
    expect(Preference.shared.videoCodec, VideoCodec.h264);
    expect(tester.takeException(), isNull);
  });

  testWidgets('codec query failure stops loading and can be retried', (
    tester,
  ) async {
    var fail = true;
    messenger.setMockMethodCallHandler(native, (call) async {
      if (call.method != 'getSupportedVideoCodecs') return null;
      if (fail) throw PlatformException(code: 'UNAVAILABLE');
      return ['h264'];
    });
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    expect(
      find.text('Could not read device codecs. Try again.'),
      findsOneWidget,
    );
    fail = false;
    final retry = find.text('Check again');
    await tester.ensureVisible(retry);
    await tester.pump();
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(find.text('Could not read device codecs. Try again.'), findsNothing);
    expect(
      tester
          .widget<DropdownButton<VideoCodec>>(
            find.byType(DropdownButton<VideoCodec>),
          )
          .value,
      VideoCodec.h264,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('retrying an HLG check keeps the requested range', (
    tester,
  ) async {
    var hdrAvailable = false;
    final ranges = <String>[];
    messenger.setMockMethodCallHandler(native, (call) async {
      if (call.method != 'getSupportedVideoCodecs') return null;
      final range = (call.arguments as Map)['dynamicRangeMode'] as String;
      ranges.add(range);
      return range == 'hlg'
          ? (hdrAvailable ? ['hevc'] : <String>[])
          : ['h264', 'hevc'];
    });
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    final hdr = find.byType(SwitchListTile);
    await tester.ensureVisible(hdr);
    await tester.pump();
    await tester.tap(hdr);
    await tester.pumpAndSettle();
    expect(Preference.shared.dynamicRangeMode, DynamicRangeMode.sdr);
    expect(
      find.text('HLG encoding is unavailable on this device.'),
      findsOneWidget,
    );
    hdrAvailable = true;
    final retry = find.text('Check again');
    await tester.ensureVisible(retry);
    await tester.pump();
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(ranges, ['sdr', 'hlg', 'hlg']);
    expect(Preference.shared.dynamicRangeMode, DynamicRangeMode.hlg);
    expect(Preference.shared.videoCodec, VideoCodec.hevc);
    expect(tester.takeException(), isNull);
  });
}
