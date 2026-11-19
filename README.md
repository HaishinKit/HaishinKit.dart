# HaishinKit Plugin

[![pub package](https://img.shields.io/pub/v/haishin_kit.svg)](https://pub.dev/packages/haishin_kit)

* A Flutter plugin for RTMP and SRT streaming on Android, iOS, and macOS, with WHIP publishing and WHEP playback on Android.

> [!NOTE]
> This project is being developed with the goal of defining a Flutter interface for HaishinKit.
> However, since development is progressing slowly, I recommend using other plugins if you need
> something stable or are in a hurry.

|             | Android | iOS       | macOS  | 
|-------------|---------|-----------|--------|
| **Support** | SDK 23+ | iOS 15.0+ | 12.0+	 |

## 💖 Sponsors

Do you need additional support? Technical support on Issues and Discussions is provided only to
contributors and academic researchers of HaishinKit. By becoming a sponsor, we can provide the
support you need.

Sponsor: [$50 per month](https://github.com/sponsors/shogo4405): Technical support via GitHub
Issues/Discussions with priority response.

## 💬 Communication

* GitHub Issues and Discussions are open spaces for communication among users and are available to
  everyone as long
  as [the code of conduct](https://github.com/HaishinKit/HaishinKit.dart?tab=coc-ov-file) is
  followed.
* Whether someone is a contributor to HaishinKit is mainly determined by their GitHub profile icon.
  If you are using the default icon, there is a chance your input might be overlooked, so please
  consider setting a custom one. It could be a picture of your pet, for example. Personally, I like
  cats.
* If you want to support e-mail based communication without GitHub.
    * Consulting fee is [$50](https://www.paypal.me/shogo4405/50USD)/1 incident. I'm able to
      response a few days.

## 🎨 Features

- **Protocols** Publish and play RTMP and SRT streams. Android also supports WHIP publishing and WHEP playback.
- **Multi Streaming** ✨Allowing live streaming to separate services. Views also support this, enabling the verification of raw video data.
- **Rounded corners** Set `ScreenObject.cornerRadius` for Android screen compositions.
- **Video mixing** ✨Possible to display any text or bitmap on a video during broadcasting or viewing. This allows for various applications such as watermarking and time display.

# 🌏 Dependencies

 Project name                                                                          | Notes                                                                          | License                                                                                                          
---------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------
 [HaishinKit for iOS, macOS and tvOS.](https://github.com/HaishinKit/HaishinKit.swift) | Camera and Microphone streaming library via RTMP, HLS for iOS, macOS and tvOS. | [BSD 3-Clause "New" or "Revised" License](https://github.com/HaishinKit/HaishinKit.swift/blob/master/LICENSE.md) 
 [HaishinKit for Android.](https://github.com/HaishinKit/HaishinKit.kt)                | Camera and Microphone streaming library via RTMP for Android.                  | [BSD 3-Clause "New" or "Revised" License](https://github.com/HaishinKit/HaishinKit.kt/blob/master/LICENSE.md)    

[API reference](https://docs.haishinkit.com/dart/latest/)

## 🔧 Setup

iOS and macOS use HaishinKit.swift 2.3.0 through Swift Package Manager.
Use Flutter 3.44 or newer and Xcode 26 or newer. The minimum deployment
targets remain iOS 15 and macOS 12.
The Flutter bridge uses Swift 5 language mode with the Swift 6 toolchain.

Enable Swift Package Manager before building an Apple application:

```sh
flutter config --enable-swift-package-manager
flutter clean
flutter pub get
```

CocoaPods installation of this plugin is no longer supported. HaishinKit.swift
2.3.0 distributes its SRT and WebRTC dependencies through Swift packages.
The Dart API is unchanged; existing `StreamSession`, `MediaMixer`, and screen
snapshot calls continue to use the shared iOS/macOS bridge.
Android uses HaishinKit.kt 0.20.3 (`haishinkit`, `rtmp`, `srt`, and `rtc`) from JitPack.
Use a complete `srt://host:port` URL, including any query options, with
`StreamSession.create` for SRT publishing or playback. In the example, enter the
complete SRT URL in the URL field; the RTMP stream name is ignored for SRT.
Screen composition, encoding, and Flutter texture previews use OpenGL; the
optional Vulkan module is not included.

Android apps consuming this plugin need `minSdk = 23` and `compileSdk = 37` or newer.
The example uses Android Gradle Plugin 9.2.1 and Gradle 9.4.1. With the current Kotlin plugin
configuration, also set these properties in `android/gradle.properties`:

```properties
android.builtInKotlin=false
android.newDsl=false
```

Please contains `macos/Runner/Info.plist` and `ios/Runner/Info.plist` files.

```xml
<key>NSCameraUsageDescription</key>
<string>your usage description here</string>
<key>NSMicrophoneUsageDescription</key>
<string>your usage description here</string>
```

Please contains `macos/Runner/Debug.Entitlements` and `macos/Runner/Release.Entitlements` files.

```xml
<key>com.apple.security.device.audio-input</key>
<true />
<key>com.apple.security.device.camera</key>
<true />
```

## Streaming on Android

HaishinKit.kt 0.20.3 supports RTMP, SRT, WHIP, and WHEP with Android API 23 or newer.

### WHIP publishing

Use the full HTTP(S) WHIP endpoint URL and capture microphone audio at 48 kHz.
Request camera and microphone permissions before attaching sources.

```dart
final mixer = await MediaMixer.create();
await mixer.attachAudio(0, AudioSource(sampleRate: 48000));
final cameras = await HaishinKitPlatformInterface.instance.videoSources;
await mixer.attachVideo(0, cameras.first);

final session = await StreamSession.create(
  'https://example.com/whip',
  StreamSessionMode.publish,
);
await mixer.startRunning();
await session.connect();

// When publishing is finished:
await session.close();
await session.dispose();
await mixer.dispose();
```

WHIP uses Opus audio and H.264 Baseline level 3.1 video. Keep custom video
settings within that profile and level.

### WHEP playback

Use the full HTTP(S) WHEP endpoint URL with playback mode.

```dart
final session = await StreamSession.create(
  'https://example.com/whep',
  StreamSessionMode.playback,
);
```

Display `StreamSessionViewTexture(session)` in the widget tree before calling
`await session.connect()`. Close and dispose the session when playback is finished.

The example's URL field accepts complete SRT, WHIP, and WHEP endpoints, including
query parameters. Open Publish for WHIP or Playback for WHEP. The stream name
field applies to RTMP.

RTC sessions use the native default ICE and authentication settings. The Dart API
currently provides no parameters for STUN/TURN servers or bearer tokens. Plain
HTTP endpoints require the consuming app's Android network security policy to
allow cleartext traffic.

### Rounded corners

Set `cornerRadius` in composition pixels to round an Android screen object's corners.

```dart
final video = VideoScreenObject()
  ..track = 0
  ..size = const ScreenObjectSize(width: 320, height: 180)
  ..cornerRadius = 16.0;
mixer.screen?.addChild(video);
```

The radius defaults to `0.0`. Assign a finite, non-negative value. Changes update
the native layout, and snapshots preserve the radius. Older snapshots that omit
`cornerRadius` load with a radius of zero. The current Dart bridge applies rounded
corners on Android.

# 🔧 Develop

Use [freezed](https://pub.dev/packages/freezed) for development. When creating data classes, please
try running the following command.

```sh
flutter pub run build_runner build --delete-conflicting-outputs
```

# 🐾 Example

An example project is available for both iOS and Android.
https://github.com/HaishinKit/HaishinKit.dart/tree/main/example

## 📜 License

BSD-3-Clause
