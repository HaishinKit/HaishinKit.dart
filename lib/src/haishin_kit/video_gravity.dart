/// Specifies how a video should be resized or scaled to fit within its container.
///
/// This enum corresponds to common video content modes, similar to
/// AVLayerVideoGravity on Apple platforms or scale types on Android.
enum VideoGravity {
  /// Stretches the video to completely fill the container.
  ///
  /// The aspect ratio is **not** preserved, which may result in distortion.
  resize(0),

  /// Scales the video to fit entirely within the container while preserving
  /// its aspect ratio.
  ///
  /// This may result in letterboxing (empty space on the top/bottom or sides).
  resizeAspect(1),

  /// Scales the video to fill the entire container while preserving
  /// its aspect ratio.
  ///
  /// Parts of the video may be clipped if the aspect ratios do not match.
  resizeAspectFill(2);

  /// Creates a [VideoGravity] with the associated integer raw value.
  const VideoGravity(this.rawValue);

  /// Integer representation of this video gravity.
  ///
  /// This is typically used for serialization, platform channel communication,
  /// or interoperability with native code.
  final int rawValue;
}
