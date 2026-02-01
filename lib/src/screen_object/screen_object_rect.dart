import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_object_rect.freezed.dart';

part 'screen_object_rect.g.dart';

/// Represents a rectangular area in screen coordinates.
///
/// This class is an immutable value object that describes the position
/// and size of a screen object using integer-based coordinates.
///
/// Typically used for layout calculation, hit testing, or serialization.
@freezed
class ScreenObjectRect with _$ScreenObjectRect {
  /// Creates a rectangle defined by its top-left position and size.
  ///
  /// - [x] The horizontal position of the rectangle's top-left corner.
  /// - [y] The vertical position of the rectangle's top-left corner.
  /// - [width] The width of the rectangle.
  /// - [height] The height of the rectangle.
  const factory ScreenObjectRect({
    required int x,
    required int y,
    required int width,
    required int height,
  }) = _ScreenObjectRect;

  factory ScreenObjectRect.fromJson(Map<String, dynamic> json) =>
      _$ScreenObjectRectFromJson(json);
}
