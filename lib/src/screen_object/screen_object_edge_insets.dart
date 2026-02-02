import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_object_edge_insets.freezed.dart';

part 'screen_object_edge_insets.g.dart';

/// Represents edge insets used for layout spacing around a [ScreenObject].
///
/// This class defines the amount of space to apply on each side
/// (top, left, bottom, and right) of a screen object. It is commonly
/// used for layout calculations, alignment adjustments, and serialization.
///
/// The values are expressed in logical pixels.
@freezed
class ScreenObjectEdgeInsets with _$ScreenObjectEdgeInsets {
  /// Creates a [ScreenObjectEdgeInsets] with the given edge values.
  ///
  /// All values are required and represent spacing in logical pixels.
  const factory ScreenObjectEdgeInsets({
    /// The inset on the top side.
    required int top,

    /// The inset on the left side.
    required int left,

    /// The inset on the bottom side.
    required int bottom,

    /// The inset on the right side.
    required int right,
  }) = _ScreenObjectEdgeInsets;

  /// Creates a [ScreenObjectEdgeInsets] instance from a JSON map.
  ///
  /// This factory is primarily used for deserialization when restoring
  /// layout state from persisted data or snapshots.
  factory ScreenObjectEdgeInsets.fromJson(Map<String, dynamic> json) =>
      _$ScreenObjectEdgeInsetsFromJson(json);
}
