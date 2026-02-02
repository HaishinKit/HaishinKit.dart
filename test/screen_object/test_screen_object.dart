import 'package:haishin_kit/haishin_kit.dart';

class TestScreenObject extends ScreenObject {
  @override
  String get type => 'test';

  Map<String, String> _elements = {};

  @override
  Map<String, String> get elements => _elements;

  @override
  set elements(Map<String, String> value) {
    _elements = value;
  }
}
