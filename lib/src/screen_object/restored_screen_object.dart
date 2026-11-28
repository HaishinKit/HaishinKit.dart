import 'horizontal_alignment.dart';
import 'vertical_alignment.dart';
import 'screen_object_container.dart';
import 'screen_object_snapshot.dart';

/// A restored scene node retaining its native type and element properties.
///
/// Unknown platform-specific types remain invisible native placeholders and
/// survive export. Layout can be edited with the ordinary ScreenObject APIs.
class RestoredScreenObject extends ScreenObjectContainer {
  RestoredScreenObject.fromSnapshot(ScreenObjectSnapshot value)
    : _type = value.type,
      super(id: value.id) {
    updateLayout(() {
      size = value.size;
      isVisible = value.isVisible;
      cornerRadius = value.cornerRadius;
      layoutMargin = value.layoutMargin;
      horizontalAlignment = HorizontalAlignment.values.firstWhere(
        (entry) => entry.rawValue == value.horizontalAlignment,
        orElse: () => HorizontalAlignment.left,
      );
      verticalAlignment = VerticalAlignment.values.firstWhere(
        (entry) => entry.rawValue == value.verticalAlignment,
        orElse: () => VerticalAlignment.top,
      );
      elements = Map.of(value.elements);
      for (final child in value.children) {
        addChild(RestoredScreenObject.fromSnapshot(child));
      }
    });
  }

  @override
  String get type => _type;
  final String _type;
}
