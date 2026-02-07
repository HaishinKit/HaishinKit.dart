import 'package:haishin_kit/src/screen_object/screen_renderer.dart';

import 'screen_object.dart';
import 'screen_object_snapshot.dart';

/// The [ScreenObjectContainer] represents a collection of screen objects.
class ScreenObjectContainer extends ScreenObject {
  @override
  final String type = "container";

  @override
  Map<String, String> elements = {};

  final List<ScreenObject> _children = [];

  /// Gets the list of children.
  List<ScreenObject> get children => _children;

  /// Adds the specified screen object as a child of the current screen object container.
  void addChild(ScreenObject child) {
    if (child.parent != null || child == this) {
      throw ArgumentError('invalid argument');
    }
    child.parent = this;
    _children.add(child);
    invalidateLayout();
  }

  /// Removes the specified screen object as a child of the current screen object container.
  void removeChild(ScreenObject child) {
    if (child.parent != this) return;
    _children.remove(child);
    child.parent = null;
    invalidateLayout();
  }

  @override
  void layout(ScreenRenderer renderer) {
    for (var child in _children) {
      child.layout(renderer);
    }
    super.layout(renderer);
  }

  @override
  ScreenObjectSnapshot snapshot() {
    return ScreenObjectSnapshot(
        type: type,
        id: id,
        frame: frame,
        isVisible: isVisible,
        layoutMargin: layoutMargin,
        horizontalAlignment: horizontalAlignment.rawValue,
        verticalAlignment: verticalAlignment.rawValue,
        elements: elements,
        children: children.map((child) {
          return child.snapshot();
        }).toList());
  }
}
