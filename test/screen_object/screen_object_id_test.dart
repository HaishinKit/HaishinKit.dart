import 'package:flutter_test/flutter_test.dart';

import 'test_screen_object.dart';

void main() {
  test('ScreenObject id should be unique', () {
    final a = TestScreenObject();
    final b = TestScreenObject();

    expect(a.id, isNot(equals(b.id)));
  });
}
