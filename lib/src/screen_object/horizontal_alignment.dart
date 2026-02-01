/// Defines horizontal alignment options.
///
/// Each value represents a horizontal positioning strategy and is associated
/// with a numeric raw value for interoperability with external systems
/// (e.g., platform channels or serialized data).
enum HorizontalAlignment {
  /// Aligns content to the left.
  left(0),

  /// Aligns content to the horizontal center.
  center(1),

  /// Aligns content to the right.
  right(2);

  /// Creates a [HorizontalAlignment] with the given integer representation.
  const HorizontalAlignment(this.rawValue);

  /// Integer representation of this alignment.
  ///
  /// This value is typically used for serialization or communication with
  /// platform-specific implementations.
  final int rawValue;
}
