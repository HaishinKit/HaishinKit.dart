import 'package:flutter/material.dart';

import 'screen_object.dart';

/// Displays a text overlay on the composition screen.
final class TextScreenObject extends ScreenObject {
  @override
  final String type = "text";

  String _value = "";

  /// The text to display.
  String get value => _value;

  /// Updates the text and invalidates layout when it changes.
  set value(String value) {
    if (_value == value) return;
    _value = value;
    invalidateLayout();
  }

  Color _color = Colors.white;

  /// The text color. Defaults to white.
  Color get color => _color;

  /// Sets the text color.
  ///
  /// If the same value is assigned, the update is ignored to avoid
  /// unnecessary layout invalidation.
  set color(Color value) {
    if (_color == value) return;
    _color = value;
    invalidateLayout();
  }

  double _fontSize = 32.0;

  /// The font size. Defaults to 32.
  double get fontSize => _fontSize;

  /// Sets the font size.
  ///
  /// The layout is invalidated only when the value actually changes.
  set fontSize(double value) {
    if (_fontSize == value) return;
    _fontSize = value;
    invalidateLayout();
  }

  @override
  Map<String, String> get elements {
    return {
      "value": value,
      "color":
          '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}',
      "fontSize": fontSize.toString()
    };
  }

  @override
  set elements(Map<String, String> value) {
    _value = value["value"] ?? "";
    _color = _colorFromHex((value["color"] ?? '#FFFFFFFF'));
    _fontSize = double.tryParse(value["fontSize"] ?? '') ?? 0.0;
    invalidateLayout();
  }
}

Color _colorFromHex(String hex) {
  final value = int.parse(
    hex.replaceFirst('#', ''),
    radix: 16,
  );
  return Color(value);
}
