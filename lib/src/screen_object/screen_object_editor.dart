import 'dart:math' as math;
import 'dart:ui';

import 'screen.dart';
import 'screen_object.dart';
import 'screen_object_size.dart';
import 'screen_object_edge_insets.dart';
import 'horizontal_alignment.dart';
import 'vertical_alignment.dart';
import 'text_screen_object.dart';

/// Edits direct children using layout measured by the native renderer.
///
/// Call [refresh] before hit testing. Transform results are cached until the
/// native renderer catches up. Selection and gesture state belong to the UI.
class ScreenObjectEditor {
  final Screen screen;
  final double minimumSize;
  Map<String, Rect> _rendered = {};
  final Map<String, Rect> _pending = {};

  ScreenObjectEditor(this.screen, {this.minimumSize = 24}) {
    if (!minimumSize.isFinite || minimumSize <= 0) {
      throw ArgumentError.value(minimumSize, 'minimumSize');
    }
  }

  Size get size =>
      Size(screen.size.width.toDouble(), screen.size.height.toDouble());

  Future<void> refresh() async {
    final values = await screen.getBounds();
    final ids = screen.children.map((child) => child.id).toSet();
    _pending.removeWhere((id, requested) {
      final actual = values[id];
      return !ids.contains(id) ||
          (actual != null &&
              (actual.topLeft - requested.topLeft).distance < 2 &&
              (actual.bottomRight - requested.bottomRight).distance < 2);
    });
    _rendered = values;
  }

  /// Latest native or pending editing bounds. Detached objects return null.
  Rect? boundsOf(ScreenObject object) {
    if (object.parent != screen) return null;
    return _pending[object.id] ?? _rendered[object.id];
  }

  /// Frontmost visible direct child at a composition point.
  ScreenObject? hitTest(Offset point) {
    if (!screen.isVisible || !(Offset.zero & size).contains(point)) return null;
    for (final object in screen.children.reversed) {
      if (object.isVisible && (boundsOf(object)?.contains(point) ?? false)) {
        return object;
      }
    }
    return null;
  }

  /// Move to a composition position without changing the requested dimensions.
  void moveTo(ScreenObject object, Offset position) {
    final bounds = boundsOf(object);
    if (bounds == null) return;
    transform(object, anchor: bounds.topLeft, destination: position);
  }

  /// Scales proportionally around [anchor] and pans that point to [destination].
  Rect? transform(
    ScreenObject object, {
    required Offset anchor,
    Offset? destination,
    double scale = 1,
  }) {
    final bounds = boundsOf(object);
    destination ??= anchor;
    if (bounds == null ||
        bounds.isEmpty ||
        size.isEmpty ||
        !anchor.dx.isFinite ||
        !anchor.dy.isFinite ||
        !destination.dx.isFinite ||
        !destination.dy.isFinite ||
        !scale.isFinite ||
        scale <= 0) {
      return null;
    }
    final maximum = math.min(
      size.width / bounds.width,
      size.height / bounds.height,
    );
    final minimum = math.min(
      maximum,
      math.max(minimumSize / bounds.width, minimumSize / bounds.height),
    );
    final factor = scale == 1 ? 1.0 : scale.clamp(minimum, maximum).toDouble();
    final dimensions = Size(bounds.width * factor, bounds.height * factor);
    final desired = destination - (anchor - bounds.topLeft) * factor;
    final origin = Offset(
      desired.dx.clamp(0.0, math.max(0.0, size.width - dimensions.width)),
      desired.dy.clamp(0.0, math.max(0.0, size.height - dimensions.height)),
    );
    final next = origin & dimensions;
    object.updateLayout(() {
      object.horizontalAlignment = HorizontalAlignment.left;
      object.verticalAlignment = VerticalAlignment.top;
      object.layoutMargin = ScreenObjectEdgeInsets(
        top: origin.dy.round(),
        left: origin.dx.round(),
        bottom: 0,
        right: 0,
      );
      if (object is TextScreenObject && factor != 1) {
        object.fontSize *= factor;
      }
      if (factor != 1) {
        object.size = ScreenObjectSize(
          width: dimensions.width.round(),
          height: dimensions.height.round(),
        );
      }
    });
    _pending[object.id] = next;
    return next;
  }

  /// Re-read measured geometry after editing content outside this editor.
  void invalidateBounds(ScreenObject object) {
    _pending.remove(object.id);
    _rendered.remove(object.id);
  }

  /// Place a newly added object using its requested size, centered on [point].
  void place(ScreenObject object, Offset point) {
    final dimensions = Size(
      object.size.width.toDouble(),
      object.size.height.toDouble(),
    );
    object.updateLayout(() {
      object.horizontalAlignment = HorizontalAlignment.left;
      object.verticalAlignment = VerticalAlignment.top;
      object.layoutMargin = ScreenObjectEdgeInsets(
        top: (point.dy - dimensions.height / 2)
            .clamp(
              0.0,
              math.max(0.0, size.height - math.max(100, dimensions.height)),
            )
            .round(),
        left: (point.dx - dimensions.width / 2)
            .clamp(
              0.0,
              math.max(0.0, size.width - math.max(200, dimensions.width)),
            )
            .round(),
        bottom: 0,
        right: 0,
      );
    });
  }
}
