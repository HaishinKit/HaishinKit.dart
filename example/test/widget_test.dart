import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit_example/main.dart';
import 'package:haishin_kit_example/preference.dart';
import 'package:haishin_kit_example/studio_theme.dart';
import 'package:haishin_kit_example/studio_widgets.dart';

void main() {
  late Preference previous;

  setUp(() {
    previous = Preference.shared;
    Preference.shared = Preference();
  });

  tearDown(() => Preference.shared = previous);

  testWidgets(
      'settings validate URLs and only enable RTMP stream names for RTMP',
      (tester) async {
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    final url = find.byKey(const ValueKey('stream-url'));
    final name = find.byKey(const ValueKey('stream-name'));
    await tester.enterText(url, 'invalid');
    await tester.pump();
    expect(find.text('Enter a supported URL with a host.'), findsOneWidget);
    await tester.enterText(url, 'https://example.com/whip?token=test');
    await tester.pump();
    expect(tester.widget<TextFormField>(name).enabled, isFalse);
    expect(Preference.shared.makeUrl(), 'https://example.com/whip?token=test');
    await tester.enterText(url, 'rtmps://example.com/live');
    await tester.pump();
    expect(tester.widget<TextFormField>(name).enabled, isTrue);
    await tester.enterText(name, 'camera');
    expect(Preference.shared.makeUrl(), 'rtmps://example.com/live/camera');
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    expect(find.text('rtmps://example.com/live'), findsOneWidget);
    expect(find.text('camera'), findsOneWidget);
  });

  testWidgets('settings scroll with large text on a small phone',
      (tester) async {
    tester.view.physicalSize = const Size(375, 700);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
        find.byKey(const ValueKey('stream-name')), 160,
        scrollable: find
            .descendant(
                of: find.byType(ListView), matching: find.byType(Scrollable))
            .first);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wide windows use a navigation rail and localized labels',
      (tester) async {
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

  testWidgets('navigation stays reachable in a short wide window with 2x text',
      (tester) async {
    tester.view.physicalSize = const Size(900, 375);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const HaishinKitExampleApp(initialDestination: 2));
    await tester.pumpAndSettle();
    final railSettings = find.descendant(
        of: find.byType(NavigationRail), matching: find.text('Settings'));
    await tester.ensureVisible(railSettings);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'pending stream operations remain visible and cannot be submitted twice',
      (tester) async {
    var calls = 0;
    await tester.pumpWidget(MaterialApp(
        theme: studioTheme(),
        home: Scaffold(
            body: StudioStreamAction(
          state: StreamSessionReadyState.connecting,
          onPressed: () => calls++,
        ))));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull);
    expect(calls, 0);
  });
}
