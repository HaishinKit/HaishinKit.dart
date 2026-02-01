import 'screen_object.dart';
import 'screen_object_snapshot.dart';

class ScreenObjectContainer extends ScreenObject {
  @override
  final String type = "container";

  @override
  Map<String, String> elements = {};

  final List<ScreenObject> _children = [];

  ///
  /// Adds the specified screen object as a child of the current screen object container.
  ///
  Future<void> addChild(ScreenObject child) async {
    child.parent = this;
    _children.add(child);
    invalidateLayout();
  }

  ///
  /// Removes the specified screen object as a child of the current screen object container.
  ///
  Future<void> removeChild(ScreenObject child) async {
    if (child.parent != this) return;
    _children.remove(child);
    child.parent = null;
    invalidateLayout();
  }

  @override
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
