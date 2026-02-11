import 'package:freezed_annotation/freezed_annotation.dart';

import 'screen_object_edge_insets.dart';
import 'screen_object_size.dart';

part 'screen_object_snapshot.freezed.dart';
part 'screen_object_snapshot.g.dart';

/// An immutable snapshot of a [ScreenObject].
///
/// This class represents the complete serialized state of a screen object
/// at a specific point in time. It is intended for layout calculation,
/// rendering, persistence, or communication across isolates or platform
/// channels.
@freezed
class ScreenObjectSnapshot with _$ScreenObjectSnapshot {
  /// Creates a new immutable [ScreenObjectSnapshot].
  ///
  /// All properties are required to ensure the snapshot fully describes
  /// the state of the screen object and its hierarchy.
  const factory ScreenObjectSnapshot({
    /// The type identifier of the screen object.
    ///
    /// This value is used to determine how the object should be interpreted
    /// or rendered (for example: `"image"`, `"text"`).
    required String type,

    /// The unique identifier of the screen object.
    ///
    /// This ID is stable across snapshots and can be used to track the same
    /// object over time.
    required String id,

    /// The layout frame of the object in screen coordinates.
    ///
    /// This defines the position and size of the object.
    required ScreenObjectSize size,

    /// Whether the object is currently visible.
    ///
    /// When `false`, the object should be ignored during rendering.
    required bool isVisible,

    /// The margin applied around the object during layout.
    ///
    /// This value affects how the object is positioned relative to its
    /// parent and siblings.
    required ScreenObjectEdgeInsets layoutMargin,

    /// The horizontal alignment of the object within its parent.
    ///
    /// The value is represented as an integer and typically maps to
    /// predefined alignment constants.
    required int horizontalAlignment,

    /// The vertical alignment of the object within its parent.
    ///
    /// The value is represented as an integer and typically maps to
    /// predefined alignment constants.
    required int verticalAlignment,

    /// A map of element-specific properties.
    ///
    /// The contents of this map depend on the object [type]. For example,
    /// an image object may store Base64-encoded bitmap data.
    required Map<String, String> elements,

    /// Child object snapshots.
    ///
    /// This allows screen objects to form a hierarchical tree structure.
    required List<ScreenObjectSnapshot> children,
  }) = _ScreenObjectSnapshot;

  /// Creates a [ScreenObjectSnapshot] from a JSON map.
  ///
  /// This factory is primarily used for deserialization of persisted or
  /// transmitted snapshot data.
  factory ScreenObjectSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenObjectSnapshotFromJson(json);
}
