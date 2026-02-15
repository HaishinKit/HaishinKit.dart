import 'dart:math';

import 'horizontal_alignment.dart';
import 'screen_object_container.dart';
import 'screen_object_edge_insets.dart';
import 'screen_object_size.dart';
import 'screen_object_snapshot.dart';
import 'screen_renderer.dart';
import 'vertical_alignment.dart';

/// The [ScreenObject] class is the abstract base class for all objects
/// that are rendered on the screen.
///
/// A screen object represents a visual element with layout information,
/// visibility state, and a hierarchical relationship to other objects.
/// Concrete subclasses are expected to provide their own rendering data
/// through [elements].
abstract class ScreenObject {
  static final _rand = Random();

  /// The logical type of this screen object.
  ///
  /// This value is typically used for serialization, debugging,
  /// or distinguishing between different kinds of screen objects.
  String get type;

  /// The unique identifier of this screen object.
  ///
  /// The identifier must be unique within the owning scene or document
  /// and is commonly used for lookup, diffing, and state management.
  final String id;

  ScreenObjectSize _size = ScreenObjectSize(width: 0, height: 0);

  /// Returns the frame rectangle of this object.
  ///
  /// The frame defines the position and size of the object
  /// in screen coordinates.
  ScreenObjectSize get size => _size;

  /// Sets the frame rectangle of this object.
  ///
  /// If the value changes, the layout is invalidated and will be
  /// recalculated during the next layout pass.
  set size(ScreenObjectSize value) {
    if (_size == value) return;
    _size = value;
    invalidateLayout();
  }

  bool _isVisible = true;

  /// Whether this object is visible.
  ///
  /// Invisible objects are typically skipped during rendering.
  bool get isVisible => _isVisible;

  /// Sets the visibility of this object.
  ///
  /// Changing this value invalidates the layout.
  set isVisible(bool value) {
    if (_isVisible == value) return;
    _isVisible = value;
    invalidateLayout();
  }

  ScreenObjectEdgeInsets _layoutMargin =
      ScreenObjectEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);

  /// The margin applied around this object during layout.
  ///
  /// This value affects how the object is positioned relative to its
  /// parent and sibling objects.
  ScreenObjectEdgeInsets get layoutMargin => _layoutMargin;

  /// Sets the layout margin for this object.
  ///
  /// Changing this value invalidates the layout.
  set layoutMargin(ScreenObjectEdgeInsets value) {
    if (_layoutMargin == value) return;
    _layoutMargin = value;
    invalidateLayout();
  }

  HorizontalAlignment _horizontalAlignment = HorizontalAlignment.left;

  /// The horizontal alignment of this object within its parent.
  HorizontalAlignment get horizontalAlignment => _horizontalAlignment;

  /// Sets the horizontal alignment.
  ///
  /// Changing this value invalidates the layout.
  set horizontalAlignment(HorizontalAlignment value) {
    if (_horizontalAlignment == value) return;
    _horizontalAlignment = value;
    invalidateLayout();
  }

  VerticalAlignment _verticalAlignment = VerticalAlignment.bottom;

  /// The vertical alignment of this object within its parent.
  VerticalAlignment get verticalAlignment => _verticalAlignment;

  /// Sets the vertical alignment.
  ///
  /// Changing this value invalidates the layout.
  set verticalAlignment(VerticalAlignment value) {
    if (_verticalAlignment == value) return;
    _verticalAlignment = value;
    invalidateLayout();
  }

  /// A map of element-specific properties.
  ///
  /// The contents of this map are defined by concrete subclasses and
  /// typically represent serialized rendering data.
  Map<String, String> get elements;

  /// Updates this object using a serialized element map.
  ///
  /// Subclasses are responsible for interpreting the provided values
  /// and restoring their internal state.
  set elements(Map<String, String> value);

  /// The parent container of this object, if any.
  ScreenObjectContainer? parent;

  /// Returns the root object of the hierarchy.
  ///
  /// This walks up the parent chain until the top-most object
  /// is reached.
  ScreenObject? get root {
    ScreenObject? parent = this.parent;
    while (parent?.parent != null) {
      parent = parent?.parent;
    }
    return parent;
  }

  bool _shouldInvalidateLayout = false;

  /// Whether this object requires a layout update.
  bool get shouldInvalidateLayout => _shouldInvalidateLayout;

  /// Creates a new [ScreenObject] with a generated unique identifier.
  ///
  /// The identifier is generated using the current timestamp and
  /// a random value to reduce the chance of collisions.
  ScreenObject()
      : id =
            '${DateTime.now().microsecondsSinceEpoch}-${_rand.nextInt(1 << 32)}';

  /// Invalidates the current layout and propagates the change to parents.
  ///
  /// This marks the object as requiring layout recalculation and ensures
  /// that parent containers are also updated.
  void invalidateLayout() {
    _shouldInvalidateLayout = true;
    if (parent != null) {
      parent?.invalidateLayout();
    }
  }

  /// Performs layout for this object using the given [renderer].
  ///
  /// Layout is only recalculated if [shouldInvalidateLayout] is `true`.
  void layout(ScreenRenderer renderer) {
    if (shouldInvalidateLayout) {
      renderer.layout(this);
    }
    _shouldInvalidateLayout = false;
  }

  /// Creates a snapshot representing the current state of this object.
  ///
  /// The returned [ScreenObjectSnapshot] contains layout, visibility,
  /// alignment, and element data, and can be used for serialization
  /// or rendering pipelines.
  ScreenObjectSnapshot snapshot() {
    return ScreenObjectSnapshot(
      type: type,
      id: id,
      size: size,
      isVisible: isVisible,
      layoutMargin: layoutMargin,
      horizontalAlignment: horizontalAlignment.rawValue,
      verticalAlignment: verticalAlignment.rawValue,
      elements: elements,
      children: [],
    );
  }
}
