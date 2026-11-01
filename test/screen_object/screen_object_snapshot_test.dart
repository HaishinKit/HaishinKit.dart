import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/src/screen_object/screen_object_snapshot.dart';
import 'package:haishin_kit/src/screen_object/screen_renderer.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('platform layout sends updated snapshot as a JSON string', () async {
    const channel = MethodChannel('com.haishinkit');
    final received = Completer<MethodCall>();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      received.complete(call);
      return null;
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, null);
    });
    final video = VideoScreenObject()
      ..size = const ScreenObjectSize(width: 90, height: 160)
      ..isVisible = false
      ..track = 1;
    PlatformScreenRenderer(42).layout(video);
    final call = await received.future;
    expect(call.method, 'Screen#layout');
    expect(call.arguments['memory'], 42);
    final snapshot = ScreenObjectSnapshot.fromJson(
        jsonDecode(call.arguments['value'] as String));
    expect(snapshot.id, video.id);
    expect(snapshot.size, video.size);
    expect(snapshot.isVisible, isFalse);
    expect(snapshot.elements, {'track': '1'});
  });

  Map<String, dynamic> fixture() => jsonDecode(
        File('test/fixtures/screen_object_snapshot.json').readAsStringSync(),
      ) as Map<String, dynamic>;

  test('shared wire format preserves every field and nested child', () {
    final json = fixture();
    final snapshot = ScreenObjectSnapshot.fromJson(json);
    expect(jsonDecode(jsonEncode(snapshot.toJson())), json);
    expect(snapshot.children[1].children[0].elements['value'],
        '字幕 🎥\nHaishinKit');
  });

  test('runtime snapshots match the native wire format', () {
    final video = VideoScreenObject()..track = 1;
    final text = TextScreenObject()
      ..value = '字幕 🎥\nHaishinKit'
      ..fontSize = 24.5
      ..color = const Color(0x8044AAFF);
    final image = ImageScreenObject()
      ..elements = ScreenObjectSnapshot.fromJson(fixture())
          .children[1]
          .children[1]
          .elements;
    final overlay = ScreenObjectContainer()
      ..addChild(text)
      ..addChild(image);
    final root = ScreenObjectContainer()
      ..addChild(video)
      ..addChild(overlay);
    for (final object in [root, video, overlay, text, image]) {
      object
        ..size = const ScreenObjectSize(width: 320, height: 180)
        ..isVisible = false
        ..layoutMargin = const ScreenObjectEdgeInsets(
            top: 11, left: 22, bottom: 33, right: 44)
        ..horizontalAlignment = HorizontalAlignment.right
        ..verticalAlignment = VerticalAlignment.middle;
    }
    final actual = jsonDecode(jsonEncode(root.snapshot().toJson()));
    // Dart generates IDs; normalize only those, leaving the wire contract intact.
    void compare(Map<String, dynamic> actual, Map<String, dynamic> expected) {
      expect(actual['id'], isNotEmpty);
      actual['id'] = expected['id'];
      for (var i = 0; i < (expected['children'] as List).length; i++) {
        compare(actual['children'][i], expected['children'][i]);
      }
      expect(actual, expected);
    }

    compare(actual, fixture());
  });

  test('text elements restore fractional font size and ARGB color', () {
    final elements = ScreenObjectSnapshot.fromJson(fixture())
        .children[1]
        .children[0]
        .elements;
    final text = TextScreenObject()..elements = elements;
    expect(text.fontSize, 24.5);
    expect(text.color, const Color(0x8044AAFF));
    expect(text.elements, elements);
  });

  test('snapshot remains stable after source and hierarchy changes', () {
    final video = VideoScreenObject()..track = 1;
    final container = ScreenObjectContainer()
      ..elements = {'label': 'original'}
      ..addChild(video);
    final snapshot = container.snapshot();
    container.elements['label'] = 'changed';
    video.track = 2;
    container.removeChild(video);
    expect(snapshot.elements, {'label': 'original'});
    expect(snapshot.children.single.elements, {'track': '1'});
  });
}
