import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_object_size.freezed.dart';
part 'screen_object_size.g.dart';

/// The requested width and height of a screen object.
@freezed
abstract class ScreenObjectSize with _$ScreenObjectSize {
  /// Creates a size from the given width and height.
  const factory ScreenObjectSize({
    /// The width of the screen object.
    required int width,

    /// The height of the screen object.
    required int height,
  }) = _ScreenObjectRect;

  factory ScreenObjectSize.fromJson(Map<String, dynamic> json) =>
      _$ScreenObjectSizeFromJson(json);
}
