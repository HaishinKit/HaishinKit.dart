import 'package:flutter/widgets.dart';
import 'package:haishin_kit/haishin_kit.dart';

/// Use the same canvas and encoder dimensions, selected before connecting.
/// Live sessions retain those dimensions until the next connection.
ScreenObjectSize publishingSize(Orientation orientation) =>
    orientation == Orientation.portrait
    ? const ScreenObjectSize(width: 720, height: 1280)
    : const ScreenObjectSize(width: 1280, height: 720);
