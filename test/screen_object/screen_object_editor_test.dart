import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.haishinkit');
  final measured = <String, List<double>>{};
  final updates = <MethodCall>[];

  setUp(() {
    measured.clear();
    updates.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          if (call.method == 'Screen#layout') updates.add(call);
          switch (call.method) {
            case 'newMediaMixer':
              return 1;
            case 'newScreen':
              return 2;
            case 'Screen#getBounds':
              return measured;
            default:
              return null;
          }
        });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('all display modes map composition and preview coordinates', () {
    const screen = Size(1280, 720);
    const fit = ScreenCoordinateTransform(
      screenSize: screen,
      previewSize: Size(640, 480),
    );
    expect(fit.toScreen(Offset.zero), const Offset(0, -120));
    expect(
      fit.rectToPreview(Offset.zero & screen),
      const Rect.fromLTWH(0, 60, 640, 360),
    );
    const fill = ScreenCoordinateTransform(
      screenSize: screen,
      previewSize: Size(720, 720),
      videoGravity: VideoGravity.resizeAspectFill,
    );
    expect(fill.toScreen(Offset.zero), const Offset(280, 0));
    const stretch = ScreenCoordinateTransform(
      screenSize: Size(1000, 500),
      previewSize: Size(200, 300),
      videoGravity: VideoGravity.resize,
    );
    expect(stretch.toPreview(const Offset(500, 250)), const Offset(100, 150));
    const invalid = ScreenCoordinateTransform(
      screenSize: Size.zero,
      previewSize: Size(200, 300),
    );
    expect(invalid.toScreen(Offset.zero), isNull);
  });

  test(
    'native measured bounds drive hit testing and detached objects are excluded',
    () async {
      final mixer = await MediaMixer.create();
      final screen = mixer.screen!;
      screen.size = const ScreenObjectSize(width: 1000, height: 1000);
      final back = ImageScreenObject();
      final front = TextScreenObject()..value = 'Text';
      screen.addChild(back);
      screen.addChild(front);
      measured[back.id] = [100, 100, 300, 200];
      measured[front.id] = [100, 100, 300, 200];
      final editor = ScreenObjectEditor(screen);
      await editor.refresh();
      expect(editor.hitTest(const Offset(150, 150)), same(front));
      front.isVisible = false;
      expect(editor.hitTest(const Offset(150, 150)), same(back));
      screen.removeChild(back);
      expect(editor.hitTest(const Offset(150, 150)), isNull);
      await mixer.dispose();
    },
  );

  test(
    'pinch scales text, preserves its anchor and accumulates before native layout',
    () async {
      final mixer = await MediaMixer.create();
      final screen = mixer.screen!
        ..size = const ScreenObjectSize(width: 1000, height: 1000);
      final text = TextScreenObject()
        ..value = 'Text'
        ..fontSize = 60;
      screen.addChild(text);
      measured[text.id] = [200, 200, 400, 300];
      final editor = ScreenObjectEditor(screen);
      await editor.refresh();
      updates.clear();
      final next = editor.transform(
        text,
        anchor: const Offset(250, 250),
        scale: 2,
      );
      expect(updates, hasLength(1));
      final sent =
          jsonDecode((updates.single.arguments as Map)['value'] as String)
              as Map;
      expect(sent['elements']['fontSize'], '120.0');
      expect(sent['size'], {'width': 400, 'height': 200});
      expect(next, const Rect.fromLTRB(150, 150, 550, 350));
      expect(text.fontSize, 120);
      editor.transform(text, anchor: const Offset(250, 250), scale: 2);
      expect(editor.boundsOf(text), const Rect.fromLTRB(50, 50, 850, 450));
      editor.transform(text, anchor: const Offset(250, 250), scale: 100);
      expect(editor.boundsOf(text), const Rect.fromLTWH(0, 0, 1000, 500));
      editor.transform(text, anchor: const Offset(250, 250), scale: 0.0001);
      expect(text.size, const ScreenObjectSize(width: 48, height: 24));
      expect(
        editor.transform(text, anchor: Offset.zero, scale: double.nan),
        isNull,
      );
      await mixer.dispose();
    },
  );
}
