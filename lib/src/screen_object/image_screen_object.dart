import 'dart:convert';
import 'dart:typed_data';
import 'screen_object.dart';

/// A [ScreenObject] that represents an image element.
///
/// This object holds a bitmap as raw binary data ([Uint8List]) and exposes it
/// as a Base64-encoded string through [elements] for serialization or
/// platform-channel communication.
class ImageScreenObject extends ScreenObject {
  /// The object type identifier.
  ///
  /// This value is used to distinguish this object as an image type.
  @override
  final String type = "image";

  /// The raw bitmap data of the image.
  ///
  /// This value is nullable. When `null`, no image data is associated
  /// with this object.
  Uint8List? _bitmap;

  /// Returns the raw bitmap data of the image.
  ///
  /// The returned value may be `null` if the image has not been set.
  Uint8List? get bitmap => _bitmap;

  /// Sets the bitmap data for this image.
  ///
  /// If the provided value is the same instance as the current bitmap,
  /// this setter does nothing.
  ///
  /// When the bitmap changes, [invalidateLayout] is called to notify
  /// that the layout or rendering state should be updated.
  set bitmap(Uint8List? value) {
    if (_bitmap == value) return;
    _bitmap = value;
    invalidateLayout();
  }

  /// A serialized representation of this object.
  ///
  /// The bitmap data is encoded as a Base64 string and stored under
  /// the `"bitmap"` key.
  ///
  /// If the bitmap is `null`, an empty string is returned instead.
  @override
  Map<String, String> get elements {
    return {
      "bitmap": (_bitmap == null) ? "" : base64Encode(_bitmap!),
    };
  }

  /// Restores the state of this object from a serialized representation.
  ///
  /// This setter is intended to decode values provided via [elements],
  /// such as Base64-encoded bitmap data.
  @override
  set elements(Map<String, String> value) {
    final base64 = value['bitmap'];
    _bitmap = (base64 == null || base64.isEmpty)
        ? null
        : base64Decode(base64);
    invalidateLayout();
  }
}
