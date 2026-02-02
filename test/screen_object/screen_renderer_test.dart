import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:haishin_kit/src/screen_object/screen_renderer.dart';

import 'test_screen_object.dart';

class FakeScreenRenderer implements ScreenRenderer {
  final List<ScreenObject> layouted = [];

  @override
  void layout(ScreenObject object) {
    layouted.add(object);
  }

  void clear() {
    layouted.clear();
  }
}

void main() {
  test('layout() calls renderer.layout()', () {
    final renderer = FakeScreenRenderer();
    final obj = TestScreenObject();
    obj.invalidateLayout();
    expect(obj.shouldInvalidateLayout, isTrue);
    obj.layout(renderer);
    expect(obj.shouldInvalidateLayout, isFalse);
    expect(renderer.layouted.single, same(obj));
  });

  test('ScreenObjectContainer with layout() calls renderer.layout()', () {
    final renderer = FakeScreenRenderer();
    var container = ScreenObjectContainer();

    var container2 = ScreenObjectContainer();
    container2.addChild(TestScreenObject());
    container2.addChild(TestScreenObject());

    container.addChild(TestScreenObject());
    container.addChild(TestScreenObject());
    container.addChild(container2);

    container.layout(renderer);

    expect(container.shouldInvalidateLayout, isFalse);
    renderer.clear();
    expect(renderer.layouted.length, 0);

    container.layout(renderer);
    expect(renderer.layouted.length, 0);
  });
}
