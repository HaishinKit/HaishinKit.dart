import 'dart:math';

import 'horizontal_alignment.dart';
import 'screen_object_container.dart';
import 'screen_object_edge_insets.dart';
import 'screen_object_rect.dart';
import 'screen_object_snapshot.dart';
import 'screen_renderer.dart';
import 'vertical_alignment.dart';

/// The [ScreenObject] class is the abstract class for all objects that are rendered on the screen.
abstract class ScreenObject {
  static final _rand = Random();

  /// Logical type of this screen object.
  ///
  /// This value is typically used for serialization, debugging,
  /// or distinguishing between different kinds of screen objects.
  String get type;

  /// Unique identifier of this screen object.
  ///
  /// The identifier must be unique within the owning scene or document
  /// and is commonly used for lookup and state management.
  final String id;

  ScreenObjectRect _frame = ScreenObjectRect(x: 0, y: 0, width: 0, height: 0);

  /// Gets the frame rectangle.
  ScreenObjectRect get frame => _frame;

  /// Sets the frame rectangle.
  set frame(ScreenObjectRect value) {
    if (_frame == value) return;
    _frame = value;
    invalidateLayout();
  }

  ScreenObjectEdgeInsets _layoutMargin =
      ScreenObjectEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);

  /// Gets the default spacing to laying out content in the screen object.
  ScreenObjectEdgeInsets get layoutMargin => _layoutMargin;

  /// Sets the layoutMargin.
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

  bool _shouldInvalidateLayout = true;

  bool get shouldInvalidateLayout => _shouldInvalidateLayout;

  ScreenObject()
      : id =
            '${DateTime.now().microsecondsSinceEpoch}-${_rand.nextInt(1 << 32)}';

  /// Invalidates the current layout and triggers a layout update.
  void invalidateLayout() {
    _shouldInvalidateLayout = true;
    if (parent != null) {
      parent?.invalidateLayout();
    }
  }

  void layout(ScreenRenderer renderer) {
    if (shouldInvalidateLayout) {
      renderer.layout(this);
    }
    _shouldInvalidateLayout = false;
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
