## Unreleased

* Add OS video encoder discovery and codec selection, including Android RTMP AV1, VP8, and VP9.
* Add HLG capture and native HDR preview surfaces on supported iOS and Android devices.
* Add sample settings for publishing codecs and HLG with protocol-aware choices.

* Match sample composition and encoder orientation before connecting; keep live output dimensions fixed.

* Update Android native dependencies to HaishinKit.kt 0.21.1 and migrate to its renamed RTC APIs.
* Update the iOS/macOS native dependency to HaishinKit.swift 2.3.2.
* Keep screen object corner radius updates in sync on iOS and macOS.

## 0.19.1

* Update Android native dependencies to HaishinKit.kt 0.20.5.
* Update the iOS/macOS native dependency to HaishinKit.swift 2.3.1.
* Replace deprecated Flutter Material imports in the library.
* Refresh the example UI and update its development dependencies. The example requires Flutter 3.47 and Dart 3.13 or newer.
* Remove obsolete CocoaPods wiring from the iOS example, which uses Swift Package Manager.
* Align iOS example simulator builds with the arm64 native SRT/RTC binaries.

## 0.19.0

* Update Android dependencies to HaishinKit.kt 0.20.3.
* Add Android WHIP publishing and WHEP playback with API 23 support.
* Add Android screen object corner radii with backward-compatible snapshots.
* Add screen object editing APIs for hit testing, positioning, resizing, and native bounds queries, with an interactive example.
* Batch layout changes while preserving automatic object sizing.
* Improve English API documentation and document WHIP/WHEP support on Android, iOS, and macOS.

## 0.18.0

* Preserve complete SRT URLs in the example without appending the RTMP stream name.
* Register Android SRT sessions through the HaishinKit.kt SRT module.
* Update Android dependencies to HaishinKit.kt 0.20.2 and require Android API 23 or newer.
* Use OpenGL for Android texture previews and explicitly release rendering resources when disposing a preview.
* Update Dart dependencies and migrate model generation to Freezed 3. Require Dart 3.12, bundled with Flutter 3.44.

## 0.17.0

* Update Android dependencies to HaishinKit.kt 0.19.0 and iOS/macOS dependencies to HaishinKit.swift 2.3.0.
* Fix cross-platform screen snapshots, including unique object identifiers, nested children, ARGB text colors, and fractional font sizes.
* Align Android screen layout and text rendering with the Swift implementation.
* Require Flutter 3.44 or newer, plus Swift Package Manager and Xcode 26 or newer for Apple platforms. Remove the obsolete CocoaPods specification; minimum deployment targets remain iOS 15 and macOS 12.
* Update the API reference and native dependency setup instructions.

## 0.16.0

* Add screen composition with image, text, and camera-track objects.
* Add native screen sizing, layout updates, and screen object disposal on iOS and macOS.
* Rename `ScreenObject.frame` to `size`.
* Add `MediaMixerOptions` for capture session configuration.
* Add video gravity controls for texture previews and update native texture handling.
* Update Android dependencies to HaishinKit.kt 0.18.2 and use the development version of HaishinKit.swift required by the screen APIs.

## 0.15.0

* Bump up HaishinKit.swift to 2.1.3
* Bump up HaishinKit.kt to 0.16.0

## 0.14.3

* Support macOS and SPM.
* Bump up HaishinKit.swift to 2.0.7

## 0.14.2

* fixed https://github.com/shogo4405/HaishinKit.dart/issues/78

## 0.14.1

* Bump up HaishinKit.swift to 2.0.4
* Bump up HaishinKit.kt to 0.14.2

## 0.14.0

* Bump up HaishinKit.kt to 0.14.1
* Bump up HaishinKit.swift to 2.0.1
    * iOS require version 13.0

## 0.13.0

* Bump up HaishinKit.kt to 0.13.2

## 0.12.0

* Bump up HaishinKit.swift to 1.7.3
    * iOS require version 12.0

## 0.11.3

* Bump up HaishinKit.swift to 1.5.8
