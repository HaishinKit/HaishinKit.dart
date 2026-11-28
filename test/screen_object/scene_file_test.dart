import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/src/screen_object/screen_object_snapshot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('com.haishinkit');
  final calls = <MethodCall>[];
  late ScreenObjectSnapshot scene;
  Completer<String>? pending;

  setUp(() {
    calls.clear();
    pending = null;
    scene = ScreenObjectContainer().snapshot().copyWith(
      type: 'screen',
      id: 'root',
      size: const ScreenObjectSize(width: 1280, height: 720),
      children: [
        ScreenObjectContainer().snapshot().copyWith(
          type: 'asset',
          id: 'video-1',
          size: const ScreenObjectSize(width: 320, height: 240),
          elements: {'source': 'file:///cache/clip.mp4', 'looping': 'true'},
        ),
        ScreenObjectContainer().snapshot().copyWith(
          type: 'custom-opaque',
          id: 'future-node',
          elements: {'vendor': 'retained'},
        ),
      ],
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          switch (call.method) {
            case 'newMediaMixer':
              return 1;
            case 'newScreen':
              return 2;
            case 'Screen#importScene':
              return pending?.future ?? jsonEncode(scene.toJson());
            case 'Screen#exportScene':
              return Uint8List.fromList([80, 75, 3, 4]);
            case 'Screen#cacheAsset':
              return 'file:///cache/clip.mp4';
        case 'Screen#getBounds':
          return {'title': [0.0, 0.0, 100.0, 40.0]};
            default:
              return null;
          }
        });
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test('restored text scales its glyph size while retaining unknown elements', () async {
    final screen = (await MediaMixer.create()).screen!;
    await screen.resize(const ScreenObjectSize(width: 640, height: 360));
    final text = RestoredScreenObject.fromSnapshot(
      TextScreenObject().snapshot().copyWith(id: 'title', elements: {
        'value': 'Saved title', 'fontSize': '20', 'color': '#FFFFFFFF', 'future': 'retained',
      }),
    );
    screen.addChild(text);
    final editor = ScreenObjectEditor(screen);
    await editor.refresh();
    editor.transform(text, anchor: Offset.zero, scale: 2);
    expect(text.elements['fontSize'], '40.0');
    expect(text.elements['future'], 'retained');
  });

  test(
    'restore adopts native IDs and graph without replaying native changes',
    () async {
      final mixer = await MediaMixer.create();
      final screen = mixer.screen!;
      final old = TextScreenObject()..value = 'old';
      screen.addChild(old);
      calls.clear();
      await screen.importScene(Uint8List.fromList([80, 75]));
      expect(calls.map((call) => call.method), ['Screen#importScene']);
      expect(screen.size, scene.size);
      expect(old.parent, isNull);
      expect(screen.children.map((child) => child.id), [
        'video-1',
        'future-node',
      ]);
      expect(screen.children.first.parent, same(screen));
      expect(screen.children.last.snapshot().elements, {'vendor': 'retained'});
      expect(screen.children.last.snapshot().type, 'custom-opaque');
      screen.children.first.layoutMargin = const ScreenObjectEdgeInsets(
        top: 20,
        left: 30,
        bottom: 0,
        right: 0,
      );
      await Future<void>.delayed(Duration.zero);
      expect(calls.any((call) => call.method == 'Screen#layout'), isTrue);
      final changed = calls.lastWhere((call) => call.method == 'Screen#layout');
      expect(jsonDecode(changed.arguments['value'])['id'], 'video-1');
    },
  );

  test(
    'failed import retains previous graph and overlapping imports are rejected',
    () async {
      final screen = (await MediaMixer.create()).screen!;
      final old = TextScreenObject()..value = 'keep';
      screen.addChild(old);
      pending = Completer<String>();
      final importing = screen.importScene(Uint8List(1));
      await expectLater(screen.importScene(Uint8List(1)), throwsStateError);
      final failure = expectLater(importing, throwsA(isA<PlatformException>()));
      pending!.completeError(PlatformException(code: 'INVALID_SCENE'));
      await failure;
      expect(screen.children.single, same(old));
    },
  );

  test(
    'export and cached asset transfer typed bytes without JSON expansion',
    () async {
      final screen = (await MediaMixer.create()).screen!;
      final bytes = Uint8List.fromList([1, 2, 3]);
      final source = await screen.cacheAsset(bytes);
      final clip = AssetScreenObject()..source = source;
      expect(clip.isLooping, isTrue);
      screen.addChild(clip);
      expect(await screen.exportScene(), [80, 75, 3, 4]);
      final call = calls.firstWhere(
        (call) => call.method == 'Screen#cacheAsset',
      );
      expect(call.arguments['bytes'], bytes);
      expect(call.arguments['extension'], 'mp4');
      expect(
        () => screen.cacheAsset(bytes, extension: '../mp4'),
        throwsArgumentError,
      );
      expect(
        () => clip.source = 'https://example.com/video.mp4',
        throwsArgumentError,
      );
    },
  );
}
