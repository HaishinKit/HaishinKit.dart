import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_object_size.freezed.dart';
part 'screen_object_size.g.dart';

/// Represents a rectangular area in screen coordinates.
///
/// This class is an immutable value object that describes the position
/// and size of a screen object using integer-based coordinates.
///
/// Typically used for layout calculation, hit testing, or serialization.
@freezed
class ScreenObjectSize with _$ScreenObjectSize {
  /// Creates a rectangle defined by its top-left position and size.
  const factory ScreenObjectSize({
    /// The width of the rectangle.
    required int width,

    /// The height of the rectangle.
    required int height,
  }) = _ScreenObjectRect;

  factory ScreenObjectSize.fromJson(Map<String, dynamic> json) =>
      _$ScreenObjectSizeFromJson(json);
}
