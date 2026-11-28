import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit_example/scene_files.dart';

void main() {
  test('restored camera background is excluded while videos remain editable', () {
    const canvas = ScreenObjectSize(width: 1280, height: 720);
    final camera = VideoScreenObject();
    expect(isCameraBackground(camera, canvas), isTrue);
    final clip = AssetScreenObject()..size = canvas;
    expect(isCameraBackground(clip, canvas), isFalse);
    final pip = VideoScreenObject()..track = 1;
    expect(isCameraBackground(pip, canvas), isFalse);
    final imported = RestoredScreenObject.fromSnapshot(camera.snapshot());
    expect(isCameraBackground(imported, canvas), isTrue);
    final container = ScreenObjectContainer()..addChild(imported);
    expect(isCameraBackground(container, canvas), isTrue);
    imported.size = const ScreenObjectSize(width: 320, height: 240);
    expect(isCameraBackground(container, canvas), isFalse);
  });
}
