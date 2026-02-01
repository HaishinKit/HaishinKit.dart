import 'screen_object.dart';

/// An object that manages offscreen rendering a text source.
final class TextScreenObject extends ScreenObject {
  @override
  final String type = "text";

  String _value = "";

  /// Gets the text string.
  String get value => _value;

  /// Sets the text string.
  set value(String value) {
    if (_value == value) return;
    _value = value;
    invalidateLayout();
  }

  int _color = 0xFFFFFFFF;

  /// Gets the text color in ARGB format (`0xAARRGGBB`).
  int get color => _color;

  /// Sets the text color.
  ///
  /// If the same value is assigned, the update is ignored to avoid
  /// unnecessary layout invalidation.
  set color(int value) {
    if (_color == value) return;
    _color = value;
    invalidateLayout();
  }

  double _size = 15.0;

  /// Gets the text size.
  double get size => _size;

  /// Sets the text size.
  ///
  /// The layout is invalidated only when the value actually changes.
  set size(double value) {
    if (_size == value) return;
    _size = value;
    invalidateLayout();
  }

  @override
  Map<String, String> get elements {
    return {
      "value": value,
      "color": '#${color.toRadixString(16).padLeft(8, '0').toUpperCase()}',
      "size": size.toString()
    };
  }

  @override
  set elements(Map<String, String> value) {
    _value = value["value"] ?? "";
    _color = int.parse((value["color"] ?? '#FFFFFFFF').replaceFirst('#', ''),
        radix: 16);
    _size = double.tryParse(value["size"] ?? '') ?? 0.0;
  }
}
