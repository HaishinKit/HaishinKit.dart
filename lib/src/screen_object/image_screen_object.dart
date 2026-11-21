import 'dart:convert';
import 'dart:typed_data';

import 'screen_object.dart';

/// Supported image formats for [ImageScreenObject].
///
/// Each enum value maps to a corresponding MIME type that can be used
/// in a `data:` URI scheme.
enum ImageScreenObjectFormat {
  /// PNG image format (`image/png`).
  png('image/png'),

  /// JPEG image format (`image/jpeg`).
  jpeg('image/jpeg');

  const ImageScreenObjectFormat(this.mime);

  /// The MIME type string associated with this image format.
  final String mime;

  /// Returns the corresponding [ImageScreenObjectFormat] for the given MIME type.
  ///
  /// If the MIME type is not supported, this method returns `null`.
  static ImageScreenObjectFormat? fromString(String mime) {
    return ImageScreenObjectFormat.values
        .cast<ImageScreenObjectFormat?>()
        .firstWhere(
          (e) => e!.mime == mime,
          orElse: () => null,
        );
  }
}

class _Keys {
  /// Key for the image source value.
  static const source = 'source';
}

/// Displays an image overlay on the composition screen.
///
/// Use [setImage] to supply encoded PNG or JPEG bytes. The native platform
/// decodes and renders the image.
class ImageScreenObject extends ScreenObject {
  /// The object type identifier.
  ///
  /// This value is used to distinguish this object as an image type.
  @override
  final String type = "image";

  String _source = "";

  /// The URI of the current image, or an empty string before an image is set.
  String get source => _source;

  /// Returns the serializable elements of this screen object.
  ///
  /// These values are used for state synchronization and persistence.
  @override
  Map<String, String> get elements {
    return {
      _Keys.source: _source,
    };
  }

  /// Restores the state of this screen object from serialized elements.
  ///
  /// Updating the elements invalidates layout.
  @override
  set elements(Map<String, String> value) {
    _source = value[_Keys.source] ?? "";
    invalidateLayout();
  }

  /// Sets the image from encoded PNG or JPEG bytes.
  ///
  /// The provided [buffer] is base64-encoded and converted into a `data:` URI
  /// using the specified [format]. If the resulting source is identical to the
  /// current one, no update is performed.
  void setImage(ImageScreenObjectFormat format, ByteBuffer buffer) {
    final source =
        "data:${format.mime};base64,${base64Encode(buffer.asUint8List())}";

    if (_source == source) return;

    _source = source;
    invalidateLayout();
  }
}
