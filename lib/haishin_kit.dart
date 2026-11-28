/// Capture, mix, preview, publish, and play audio and video on native platforms.
///
/// Use [MediaMixer] to attach input sources and compose overlays through its
/// [Screen], [StreamSession] for network sessions, and [StreamSessionViewTexture]
/// for native video previews and playback.
///
/// ## Platform integration
///
/// Use Flutter 3.44+, Dart 3.12+, and Xcode 26+ for Apple builds. The native Apple
/// bridge uses HaishinKit.swift 2.3.2 through Swift Package Manager, targeting
/// iOS 15 and macOS 12. CocoaPods installation of this plugin is not supported.
/// Enable Swift Package Manager before resolving the consuming app:
///
/// ```sh
/// flutter config --enable-swift-package-manager
/// flutter clean
/// flutter pub get
/// ```
///
/// Add camera/microphone usage descriptions to the app's iOS/macOS Info.plist:
///
/// ```xml
/// <key>NSCameraUsageDescription</key>
/// <string>Use the camera for publishing.</string>
/// <key>NSMicrophoneUsageDescription</key>
/// <string>Use the microphone for publishing.</string>
/// ```
///
/// On macOS, enable `com.apple.security.device.audio-input` and
/// `com.apple.security.device.camera` in the app's Debug and Release entitlements.
///
/// Android uses HaishinKit.kt 0.21.1 modules from JitPack and OpenGL composition.
/// Use compile SDK 37+. The native bridge declares API 23, while Flutter 3.44
/// requires an Android app minimum of API 24. With the repository's current
/// Kotlin plugin configuration, set these Android Gradle properties:
///
/// ```properties
/// android.builtInKotlin=false
/// android.newDsl=false
/// ```
///
/// Request camera and microphone permissions before capture. Android WHIP audio
/// publishing needs an Opus encoder (available on Android 10+) and 48 kHz PCM.
/// Plain HTTP requires the consuming app to allow cleartext traffic in its
/// Android network-security configuration.
///
/// ## Native platform feature comparison
///
/// Verified against HaishinKit.swift **2.3.2** and HaishinKit.kt **0.21.1** on
/// 2026-11-28. These are native library capabilities, not a promise that every
/// feature is exposed by Flutter or supported by every device/server.
/// The Flutter baseline below is the development branch after the native
/// dependency migration, not the published `haishin_kit: 0.19.1` package.
///
/// ### Native video and transport support
///
/// | Capability | Swift 2.3.2 | Kotlin 0.21.1 |
/// | --- | --- | --- |
/// | RTMP/RTMPS camera encoding | H.264, HEVC | H.264, HEVC, AV1, VP8, VP9 |
/// | RTMP/RTMPS video reception | H.264, HEVC; AV1 with a VideoToolbox hardware decoder | H.264, HEVC, AV1, VP8, VP9 with suitable OS decoders |
/// | SRT MPEG-TS video, send/receive | H.264, HEVC | H.264, HEVC |
/// | SRT MPEG-TS audio | AAC | AAC |
/// | WHIP/WHEP video | H.264 | H.264, VP8, VP9 (profile 0) |
/// | WHIP/WHEP audio | Opus | Opus |
/// | HLG composition | 10-bit HLG with HEVC Main10 encoding | 10-bit HLG with HEVC Main10 or AV1 Main10 encoding |
/// | Rendering | Core Image / Metal | OpenGL; optional Vulkan for SDR |
/// | Portable scenes | Native SceneFile ZIP with embedded media | Same portable SceneFile format |
/// | Local video assets | AssetScreenObject; video track only | AssetScreenObject; video track only |
///
/// Codec support has three separate requirements: the transport must carry it,
/// the OS must provide a compatible encoder/decoder, and the peer must accept
/// the stream. Profile, size, frame rate and concurrent codec use also matter.
/// An OS capability listing is not a successful encode/decode test.
/// The SRT rows describe these SDKs' MPEG-TS implementation, rather than every
/// codec that the MPEG-TS container can represent.
///
/// Swift's default streaming encoder uses VideoToolbox H.264/HEVC. Its optional
/// AOMHaishinKit and VPXHaishinKit products provide separate codec APIs; their
/// existence does not add AV1/VP8/VP9 camera publishing to the RTMP or RTC tables
/// above. AV1 RTMP reception has no software fallback, and its HDR metadata path
/// is outside the current Swift implementation. On unsupported hardware, native
/// Swift keeps supported audio playing and ignores AV1 video.
///
/// ### Flutter exposure and migration status
///
/// The following additions are **unreleased**. PR references describe the
/// implementation work; use a published Dart release only after its changelog
/// includes the required feature.
///
/// | Flutter capability | iOS / macOS | Android | Availability |
/// | --- | --- | --- | --- |
/// | RTMP/RTMPS, SRT, WHIP publishing and WHEP playback | Native session bridge | Native session bridge | Development baseline |
/// | RTMP playback codec detection | Native H.264/HEVC/AV1 receive behavior | Native H.264/HEVC/AV1/VP8/VP9 receive behavior | Native dependency migration; no publishing codec selection required |
/// | OS encoder discovery and codec selection | H.264/HEVC; WHIP H.264 | RTMP five codecs; SRT H.264/HEVC; WHIP H.264/VP8/VP9 | [PR #204](https://github.com/HaishinKit/HaishinKit.dart/pull/204) |
/// | HLG capture and native HDR preview | iOS 16+; macOS remains SDR | Android 13+ | RTMP only; [PR #204](https://github.com/HaishinKit/HaishinKit.dart/pull/204) |
/// | Scene export/import and local video assets | iOS/macOS | Android | [PR #206](https://github.com/HaishinKit/HaishinKit.dart/pull/206) |
/// | Explicit audio codec selection / complete audio capability report | Not exposed | Not exposed | Protocol defaults: AAC for RTMP/SRT, Opus for WHIP |
/// | Native recording and video-effect controls | Not exposed | Not exposed | Native SDK APIs are broader than the Flutter bridge |
/// | Vulkan backend selection | Not applicable | Not exposed; Flutter previews use OpenGL | Native module selection does not change Flutter's preview API |
///
/// HLG additionally needs a compatible camera, Main10 encoder, display, and
/// server/player. HDR previews require the new native-surface widget; the legacy
/// Flutter texture is SDR-only. The portable scene bridge packages local media,
/// not capture permissions/devices, session settings or connection credentials.
/// Its archive/resource limit is 32 MiB. Unsupported scene objects remain
/// invisible and retain their serialized content for re-export.
///
/// Native Swift also targets tvOS, visionOS and Mac Catalyst; this Flutter
/// package declares only iOS and macOS on Apple platforms. Do not infer Flutter
/// support from native package targets. AssetScreenObject is unavailable on
/// native visionOS, and its example uses a generated test signal for publishing.
///
/// Sources for this comparison:
/// [Swift encoder settings](https://github.com/HaishinKit/HaishinKit.swift/blob/2.3.2/HaishinKit/Sources/Codec/VideoCodecSettings.swift),
/// [Swift AV1 reception](https://github.com/HaishinKit/HaishinKit.swift/blob/2.3.2/HaishinKit/Sources/Docs.docc/av1-playback.md),
/// [Swift RTC formats](https://github.com/HaishinKit/HaishinKit.swift/blob/2.3.2/RTCHaishinKit/Sources/RTC/RTCStream.swift),
/// [Kotlin RTMP muxer](https://github.com/HaishinKit/HaishinKit.kt/blob/0.21.1/rtmp/src/main/java/com/haishinkit/rtmp/RtmpMuxer.kt),
/// [Kotlin SRT stream](https://github.com/HaishinKit/HaishinKit.kt/blob/0.21.1/srt/src/main/java/com/haishinkit/srt/SrtStream.kt),
/// [Kotlin RTC formats](https://github.com/HaishinKit/HaishinKit.kt/blob/0.21.1/rtc/src/main/java/com/haishinkit/rtc/RtcVideoCodec.kt).
/// Refresh both the native release tags and Flutter exposure table when
/// upgrading dependencies; a platform codec's presence alone is insufficient.
///
/// ## Publishing and session lifecycle
///
/// The transport comes from the URL. Include the RTMP stream name in the full
/// RTMP/RTMPS URL; pass complete SRT URLs with their query options. WHIP publishes
/// and WHEP plays back using their respective complete HTTP(S) endpoints.
///
/// ```dart
/// final mixer = await MediaMixer.create();
/// await mixer.attachAudio(0, AudioSource(sampleRate: 48000));
/// final cameras = await HaishinKitPlatformInterface.instance.videoSources;
/// if (cameras.isEmpty) throw StateError('No camera is available.');
/// await mixer.attachVideo(0, cameras.first);
/// final session = await StreamSession.create(
///   'https://example.com/whip',
///   StreamSessionMode.publish,
/// );
/// await mixer.startRunning();
/// await session.connect();
/// // When finished, including after failure or cancellation:
/// await session.close();
/// await session.dispose();
/// await mixer.dispose();
/// ```
///
/// Observe [StreamSession.readyState] and handle [StreamSessionException] from
/// connection attempts. The 48 kHz capture option in this example applies to
/// Android; native capture behavior on Apple platforms is managed by the bridge.
/// Android WHIP uses Opus and H.264 Baseline level 3.1, so keep custom video
/// settings within those capabilities.
///
/// ## Playback
///
/// ```dart
/// final session = await StreamSession.create(
///   'https://example.com/whep',
///   StreamSessionMode.playback,
/// );
/// ```
///
/// Put [StreamSessionViewTexture] in the widget tree before calling
/// [StreamSession.connect]. Close and dispose the session when playback finishes.
/// SRT and HTTP(S) endpoints preserve paths/query parameters and do not use a
/// separate RTMP stream-name field. The Dart API currently uses native default
/// ICE/authentication settings, without parameters for bearer tokens or STUN/TURN.
///
/// ## Developing the plugin
///
/// Regenerate data classes after editing their source definitions:
///
/// ```sh
/// dart run build_runner build --delete-conflicting-outputs
/// ```
library;

// HaishinKit
export 'src/haishin_kit/platform_interface_haishin_kit.dart';
// MediaMixer
export 'src/media_mixer/audio_mixer_settings.dart';
export 'src/media_mixer/audio_source.dart';
export 'src/media_mixer/media_mixer.dart';
export 'src/media_mixer/media_mixer_exception.dart';
export 'src/media_mixer/media_mixer_options.dart';
export 'src/media_mixer/video_mixer_settings.dart';
export 'src/media_mixer/video_source.dart';
export 'src/screen_object/horizontal_alignment.dart';
// ScreenObject
export 'src/haishin_kit/video_gravity.dart';
export 'src/screen_object/screen_coordinate_transform.dart';
export 'src/screen_object/screen_object_editor.dart';
export 'src/screen_object/image_screen_object.dart';
export 'src/screen_object/screen.dart';
export 'src/screen_object/screen_object.dart';
export 'src/screen_object/screen_object_container.dart';
export 'src/screen_object/screen_object_edge_insets.dart';
export 'src/screen_object/screen_object_size.dart';
export 'src/screen_object/text_screen_object.dart';
export 'src/screen_object/vertical_alignment.dart';
export 'src/screen_object/video_screen_object.dart';
// StreamSession
export 'src/stream_session/audio_codec_settings.dart';
export 'src/stream_session/stream_session.dart';
export 'src/stream_session/stream_session_exception.dart';
export 'src/stream_session/stream_session_mode.dart';
export 'src/stream_session/stream_session_ready_state.dart';
export 'src/stream_session/stream_session_view_texture.dart';
export 'src/stream_session/video_codec_settings.dart';
