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
/// ## Video assets and portable scenes
///
/// [AssetScreenObject] renders a local video's picture without mixing its audio.
/// Supply a file URI or copy bundled/downloaded bytes into screen-owned storage:
///
/// ```dart
/// final source = await mixer.screen!.cacheAsset(videoBytes, extension: 'mp4');
/// final clip = AssetScreenObject()
///   ..source = source
///   ..isLooping = true
///   ..size = const ScreenObjectSize(width: 320, height: 240);
/// mixer.screen!.addChild(clip);
/// ```
///
/// `await mixer.screen!.exportScene()` captures the actual native composition,
/// including the default camera node, as a `.scene` ZIP with local media.
/// Persist the returned bytes using your app's file-storage UI. Restore with
/// `await mixer.screen!.importScene(bytes)` while disconnected. Capture must be
/// running for Android's frame-coherent export. Await scene operations before
/// editing or disposing. Scene archives and packaged resources are limited to
/// 32 MiB by the Flutter bridge. The native reader validates the shared archive
/// format. Scene files do not attach capture devices or restore session settings.
///
/// Imported children are [RestoredScreenObject] nodes with stable IDs, editable
/// layout and retained type/element properties. Unsupported objects/resources
/// survive subsequent exports without rendering. Screen-owned media URIs expire
/// on disposal; export a scene before disposing to persist media elsewhere.
///
/// ## Developing the plugin
///
/// Regenerate data classes after editing their source definitions:
///
/// ```sh
/// dart run build_runner build --delete-conflicting-outputs
/// ```
library;

export 'src/screen_object/asset_screen_object.dart';
export 'src/screen_object/restored_screen_object.dart';

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
