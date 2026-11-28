import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:haishin_kit/haishin_kit.dart';

/// The full-size track-zero camera is a background, not an editable overlay.
bool isCameraBackground(ScreenObject object, ScreenObjectSize canvas) {
  final fullSize =
      (object.size.width == 0 || object.size.width == canvas.width) &&
      (object.size.height == 0 || object.size.height == canvas.height) &&
      object.layoutMargin ==
          const ScreenObjectEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
  if (!fullSize) return false;
  if (object.type == 'video') return (object.elements['track'] ?? '0') == '0';
  if (object is ScreenObjectContainer && object.children.length == 1) {
    return isCameraBackground(object.children.single, canvas);
  }
  return false;
}

/// Sample file dialogs. Read incrementally so oversized files are rejected
/// before allocating them for the native method channel.
class SceneFiles {
  static const maximumBytes = 32 * 1024 * 1024;

  Future<Uint8List?> open() async {
    final file = await FilePicker.pickFile();
    if (file == null) return null;
    final size = await file.length();
    if (size != null && size > maximumBytes) {
      throw StateError('Scene exceeds 32 MiB');
    }
    final bytes = BytesBuilder(copy: false);
    await for (final chunk in file.readAsByteStream()) {
      if (bytes.length + chunk.length > maximumBytes) {
        throw StateError('Scene exceeds 32 MiB');
      }
      bytes.add(chunk);
    }
    return bytes.takeBytes();
  }

  Future<bool> save(Uint8List bytes) async =>
      await FilePicker.saveFile(
        fileName: 'HaishinKit.scene',
        bytes: bytes,
        mimeType: 'application/zip',
      ) !=
      null;
}
