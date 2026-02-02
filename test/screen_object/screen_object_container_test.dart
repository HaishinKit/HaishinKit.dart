import 'package:flutter_test/flutter_test.dart';
import 'package:haishin_kit/haishin_kit.dart';

import 'test_screen_object.dart';

void main() {
  test('ScreenObjectContainer addChild', () {
    var container = ScreenObjectContainer();
    container.addChild(TestScreenObject());
    container.addChild(TestScreenObject());
    expect(container.children.length, 2);
  });

  test('ScreenObjectContainer addChild and removeChild', () {
    var container = ScreenObjectContainer();
    var text = TestScreenObject();
    container.addChild(text);
    container.removeChild(text);
    expect(container.children.length, 0);
  });

  test('ScreenObjectContainer addChild with ScreenObjectContainer', () {
    var container = ScreenObjectContainer();

    var container2 = ScreenObjectContainer();
    container2.addChild(TestScreenObject());
    container2.addChild(TestScreenObject());

    container.addChild(TestScreenObject());
    container.addChild(TestScreenObject());
    container.addChild(container2);

    expect(container.children.length, 3);
  });

  test('ScreenObjectContainer toSnapshot()', () {
    var container = ScreenObjectContainer();

    var container2 = ScreenObjectContainer();
    container2.addChild(TestScreenObject());
    container2.addChild(TestScreenObject());

    container.addChild(TestScreenObject());
    container.addChild(TestScreenObject());
    container.addChild(container2);

    expect(container.snapshot().children.length, 3);
    expect(container2.snapshot().children.length, 2);
  });
}
