# HaishinKit Plugin

[![pub package](https://img.shields.io/pub/v/haishin_kit.svg)](https://pub.dev/packages/haishin_kit)

* A Flutter plugin for iOS, Android. Camera and Microphone streaming library via RTMP.

> [!NOTE]
> This project is being developed with the goal of defining a Flutter interface for HaishinKit.
> However, since development is progressing slowly, I recommend using other plugins if you need
> something stable or are in a hurry.

|             | Android | iOS       | macOS  | 
|-------------|---------|-----------|--------|
| **Support** | SDK 21+ | iOS 15.0+ | 12.0+	 |

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
- **Protocols** ✨Publish and playback feature are available RTMP.
- **Multi Streaming** ✨Allowing live streaming to separate services. Views also support this, enabling the verification of raw video data.
- **Video mixing** ✨Possible to display any text or bitmap on a video during broadcasting or viewing. This allows for various applications such as watermarking and time display.

# 🌏 Dependencies

 Project name                                                                          | Notes                                                                          | License                                                                                                          
---------------------------------------------------------------------------------------|--------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------
 [HaishinKit for iOS, macOS and tvOS.](https://github.com/HaishinKit/HaishinKit.swift) | Camera and Microphone streaming library via RTMP, HLS for iOS, macOS and tvOS. | [BSD 3-Clause "New" or "Revised" License](https://github.com/HaishinKit/HaishinKit.swift/blob/master/LICENSE.md) 
 [HaishinKit for Android.](https://github.com/HaishinKit/HaishinKit.kt)                | Camera and Microphone streaming library via RTMP for Android.                  | [BSD 3-Clause "New" or "Revised" License](https://github.com/HaishinKit/HaishinKit.kt/blob/master/LICENSE.md)    

## 🔧 Setup

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
