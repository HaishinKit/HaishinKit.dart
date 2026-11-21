import 'dart:math' as math;
import 'dart:ui';

import '../haishin_kit/video_gravity.dart';

/// Maps composition pixels to preview-local coordinates and back.
class ScreenCoordinateTransform {
  final Size screenSize;
  final Size previewSize;
  final VideoGravity videoGravity;

  const ScreenCoordinateTransform({
    required this.screenSize,
    required this.previewSize,
    this.videoGravity = VideoGravity.resizeAspect,
  });

  bool get _valid =>
      screenSize.width.isFinite &&
      screenSize.height.isFinite &&
      previewSize.width.isFinite &&
      previewSize.height.isFinite &&
      screenSize.width > 0 &&
      screenSize.height > 0 &&
      previewSize.width > 0 &&
      previewSize.height > 0;

  Size get _scale {
    final x = previewSize.width / screenSize.width;
    final y = previewSize.height / screenSize.height;
    return switch (videoGravity) {
      VideoGravity.resize => Size(x, y),
      VideoGravity.resizeAspect => Size.square(math.min(x, y)),
      VideoGravity.resizeAspectFill => Size.square(math.max(x, y)),
    };
  }

  Offset get _offset => Offset(
    (previewSize.width - screenSize.width * _scale.width) / 2,
    (previewSize.height - screenSize.height * _scale.height) / 2,
  );

  /// Returns null for invalid geometry. Letterbox points are not clamped.
  Offset? toScreen(Offset point) {
    if (!_valid || !point.dx.isFinite || !point.dy.isFinite) return null;
    final local = point - _offset;
    return Offset(local.dx / _scale.width, local.dy / _scale.height);
  }

  /// Returns null for invalid geometry. Cropped content is not clipped.
  Offset? toPreview(Offset point) {
    if (!_valid || !point.dx.isFinite || !point.dy.isFinite) return null;
    return Offset(point.dx * _scale.width, point.dy * _scale.height) + _offset;
  }

  /// Maps a composition rectangle to the preview.
  Rect? rectToPreview(Rect rect) {
    final origin = toPreview(rect.topLeft);
    final end = toPreview(rect.bottomRight);
    return origin == null || end == null ? null : Rect.fromPoints(origin, end);
  }
}
