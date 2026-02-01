/// Defines vertical alignment options.
///
/// Each value represents a vertical positioning strategy and is associated
/// with a numeric raw value for interoperability with external systems
/// (e.g., platform channels or serialized data).
enum VerticalAlignment {
  /// Aligns content to the top.
  top(0),

  /// Aligns content to the vertical center.
  middle(1),

  /// Aligns content to the bottom.
  bottom(2);

  /// Creates a [VerticalAlignment] with the given integer representation.
  const VerticalAlignment(this.rawValue);

  /// Integer representation of this alignment.
  ///
  /// This value is typically used for serialization or communication with
  /// platform-specific implementations.
  final int rawValue;
}
