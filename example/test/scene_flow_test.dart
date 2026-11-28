import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit_example/publish_page.dart';
import 'package:haishin_kit_example/scene_files.dart';
import 'package:haishin_kit_example/studio_theme.dart';
import 'package:material_ui/material_ui.dart';

class _Files extends SceneFiles {
  Uint8List? saved;
  @override
  Future<Uint8List?> open() async => Uint8List.fromList([80, 75]);
  @override
  Future<bool> save(Uint8List bytes) async { saved = bytes; return true; }
}

void main() {
  testWidgets('sample loads and saves scenes, publishes restored size, and locks live loading', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(700, 1000);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const native = MethodChannel('com.haishinkit');
    const events = MethodChannel('com.haishinkit.eventchannel/3');
    const audio = MethodChannel('com.ryanheise.audio_session');
    const permissions = MethodChannel('flutter.baseflow.com/permissions/methods');
    final calls = <MethodCall>[];
    final restored = ScreenObjectContainer().snapshot().copyWith(
      type: 'screen', size: const ScreenObjectSize(width: 640, height: 360),
      children: [VideoScreenObject().snapshot()],
    );
    void emit(String state) => ServicesBinding.instance.channelBuffers.push(
      events.name, const StandardMethodCodec().encodeSuccessEnvelope(state), (_) {});
    messenger.setMockMethodCallHandler(events, (_) async => null);
    messenger.setMockMethodCallHandler(audio, (_) async => null);
    messenger.setMockMethodCallHandler(permissions, (call) async => {for (final id in call.arguments as List) id: 1});
    messenger.setMockMethodCallHandler(native, (call) async {
      calls.add(call);
      switch (call.method) {
        case 'getVideoSources': return jsonEncode([{'id': '0', 'name': 'Back', 'position': 'back'}]);
        case 'newMediaMixer': return 1;
        case 'newScreen': return 2;
        case 'newSession': return 3;
        case 'Screen#getBounds': return <String, dynamic>{};
        case 'StreamSession#registerTexture':
        case 'StreamSession#updateTexture': return 1;
        case 'Screen#importScene': return jsonEncode(restored.toJson());
        case 'Screen#exportScene': return Uint8List.fromList([80, 75, 3, 4]);
        case 'Screen#cacheAsset': return 'file:///cache/movie.mp4';
        case 'StreamSession#connect': emit('open'); return null;
        default: return null;
      }
    });
    addTearDown(() { for (final channel in [native, events, audio, permissions]) {
      messenger.setMockMethodCallHandler(channel, null);
    }});
    final files = _Files();
    await tester.pumpWidget(MaterialApp(theme: studioTheme(), home: Scaffold(body: PublishPage(sceneFiles: files))));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 100));
    Future<void> tools() async {
      await tester.tap(find.byTooltip('Camera tools'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
    }
    Future<void> press(String label) async {
      await tester.ensureVisible(find.text(label));
      await tester.pump();
      await tester.tap(find.text(label));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump();
    }
    await tools();
    await press('Load scene');
    expect(calls.any((call) => call.method == 'Screen#importScene'), isTrue);
    await tools();
    await press('Save scene');
    expect(files.saved, [80, 75, 3, 4]);
    await tools();
    await press('Add sample video');
    final assets = calls.where((call) => call.method == 'Screen#addChild').map((call) => jsonDecode(call.arguments['value'])).where((node) => node['type'] == 'asset').toList();
    expect(assets.single['elements']['source'], 'file:///cache/movie.mp4');
    await tester.tap(find.widgetWithIcon(FilledButton, Icons.play_arrow));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 100));
    expect(calls.any((call) => call.method == 'StreamSession#setVideoSettings'), isTrue,
        reason: calls.map((call) => call.method).join(', '));
    final encoder = calls.lastWhere((call) => call.method == 'StreamSession#setVideoSettings');
    expect(encoder.arguments['settings'], {'width': 640, 'height': 360});
    await tools();
    final load = tester.widget<OutlinedButton>(find.widgetWithText(OutlinedButton, 'Load scene'));
    expect(load.onPressed, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
