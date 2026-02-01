import 'dart:math';

import 'horizontal_alignment.dart';
import 'screen.dart';
import 'screen_object_container.dart';
import 'screen_object_edge_insets.dart';
import 'screen_object_rect.dart';
import 'screen_object_snapshot.dart';
import 'vertical_alignment.dart';

abstract class ScreenObject {
  static final _rand = Random();

  String get type;

  final String id;

  ScreenObjectRect _frame = ScreenObjectRect(x: 0, y: 0, width: 0, height: 0);

  ScreenObjectRect get frame => _frame;

  set frame(ScreenObjectRect value) {
    if (_frame == value) return;
    _frame = value;
    invalidateLayout();
  }

  ScreenObjectEdgeInsets _layoutMargin =
      ScreenObjectEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);

  ScreenObjectEdgeInsets get layoutMargin => _layoutMargin;

  set layoutMargin(ScreenObjectEdgeInsets value) {
    if (_layoutMargin == value) return;
    _layoutMargin = value;
    invalidateLayout();
  }

  HorizontalAlignment _horizontalAlignment = HorizontalAlignment.left;

  HorizontalAlignment get horizontalAlignment => _horizontalAlignment;

  set horizontalAlignment(HorizontalAlignment value) {
    if (_horizontalAlignment == value) return;
    _horizontalAlignment = value;
    invalidateLayout();
  }

  VerticalAlignment _verticalAlignment = VerticalAlignment.bottom;

  VerticalAlignment get verticalAlignment => _verticalAlignment;

  set verticalAlignment(VerticalAlignment value) {
    if (_verticalAlignment == value) return;
    _verticalAlignment = value;
    invalidateLayout();
  }

  Map<String, String> get elements;

  set elements(Map<String, String> value);

  ScreenObjectContainer? parent;

  ScreenObject? get root {
    ScreenObject? parent = this.parent;
    while (parent?.parent != null) {
      parent = parent?.parent;
    }
    return parent;
  }

  ScreenObject()
      : id =
            '${DateTime.now().microsecondsSinceEpoch}-${_rand.nextInt(1 << 32)}';

  void invalidateLayout() {
    if (root is Screen) {
      (root as Screen).update(this);
    }
  }

  ScreenObjectSnapshot snapshot() {
    return ScreenObjectSnapshot(
        type: type,
        id: id,
        frame: frame,
        layoutMargin: layoutMargin,
        horizontalAlignment: horizontalAlignment.rawValue,
        verticalAlignment: verticalAlignment.rawValue,
        elements: elements,
        children: []);
  }
}
