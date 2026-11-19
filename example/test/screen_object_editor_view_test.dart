import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit_example/screen_object_editor_view.dart';

void main() {
  const channel = MethodChannel('com.haishinkit');
  final measured = <String, List<double>>{};

  setUp(() {
    measured.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            channel,
            (call) async => switch (call.method) {
                  'newMediaMixer' => 1,
                  'newScreen' => 2,
                  'Screen#getBounds' => measured,
                  _ => null,
                });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  testWidgets('select, resize and delete an image', (tester) async {
    final mixer = await MediaMixer.create();
    final screen = mixer.screen!
      ..size = const ScreenObjectSize(width: 1000, height: 1000);
    final image = ImageScreenObject();
    screen.addChild(image);
    measured[image.id] = [100, 100, 300, 300];
    await tester.pumpWidget(MaterialApp(
      theme: ThemeData(platform: TargetPlatform.macOS),
      home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 600,
            height: 600,
            child: ScreenObjectEditorView(
                screen: screen, child: const ColoredBox(color: Colors.black)),
          )),
    ));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tapAt(const Offset(120, 120));
    await tester.pump();
    expect(find.byTooltip('Delete object'), findsOneWidget);
    await tester.tap(find.byTooltip('Enlarge object'));
    await tester.pump();
    expect(image.size, const ScreenObjectSize(width: 240, height: 240));
    await tester.tap(find.byTooltip('Delete object'));
    await tester.pump();
    expect(screen.children, isEmpty);
    expect(find.byTooltip('Delete object'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await mixer.dispose();
  });

  testWidgets('background tap opens insertion menu and adds text',
      (tester) async {
    final mixer = await MediaMixer.create();
    final screen = mixer.screen!
      ..size = const ScreenObjectSize(width: 1000, height: 1000);
    await tester.pumpWidget(MaterialApp(
        home: ScreenObjectEditorView(
      screen: screen,
      child: const ColoredBox(color: Colors.black),
    )));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tapAt(const Offset(400, 300));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Add object'), findsOneWidget);
    await tester.tap(find.text('Text'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(screen.children.single, isA<TextScreenObject>());
    expect((screen.children.single as TextScreenObject).value, 'New text');
    await tester.pumpWidget(const SizedBox.shrink());
    await mixer.dispose();
  });
  testWidgets('tap text and save edited content', (tester) async {
    final mixer = await MediaMixer.create();
    final screen = mixer.screen!
      ..size = const ScreenObjectSize(width: 1000, height: 1000);
    final text = TextScreenObject()..value = 'Before';
    screen.addChild(text);
    measured[text.id] = [100, 100, 300, 200];
    await tester.pumpWidget(MaterialApp(
        home: Align(
      alignment: Alignment.topLeft,
      child: SizedBox(
          width: 600,
          height: 600,
          child: ScreenObjectEditorView(
            screen: screen,
            child: const ColoredBox(color: Colors.black),
          )),
    )));
    await tester.pump(const Duration(milliseconds: 80));
    await tester.tapAt(const Offset(120, 90));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Edit text'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'After\nSecond line');
    await tester.tap(find.text('Save'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(text.value, 'After\nSecond line');
    await tester.pumpWidget(const SizedBox.shrink());
    await mixer.dispose();
  });
}
