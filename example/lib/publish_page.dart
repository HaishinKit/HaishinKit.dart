import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:haishin_kit/haishin_kit.dart';
import 'package:permission_handler/permission_handler.dart';

import 'preference.dart';
import 'screen_object_editor_view.dart';
import 'studio_theme.dart';
import 'studio_widgets.dart';

class PublishPage extends StatefulWidget {
  const PublishPage({super.key, this.onOpenSettings});

  final VoidCallback? onOpenSettings;

  @override
  State<PublishPage> createState() => _PublishState();
}

class _PublishState extends State<PublishPage> {
  MediaMixer? _mixer;
  StreamSession? _session;
  Stream<StreamSessionReadyState>? _states;
  List<VideoSource> _videoSources = [];
  VideoSource? _mainVideoSource;
  Orientation? _orientation;
  bool _initializing = false;
  bool _busy = false;
  bool _changingCamera = false;
  bool _secondaryCameraEnabled = false;
  VideoScreenObject? _secondaryVideoObject;
  bool _permissionDenied = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    unawaited(_release(_session, _mixer));
    super.dispose();
  }

  Future<void> _release(StreamSession? session, MediaMixer? mixer) async {
    try {
      await session?.dispose();
    } catch (error) {
      debugPrint('Could not release publishing session: $error');
    }
    try {
      await mixer?.dispose();
    } catch (error) {
      debugPrint('Could not release capture: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.orientationOf(context);
    if (_mixer != null && _orientation != orientation) {
      _orientation = orientation;
      _mixer!.screen?.size = orientation == Orientation.portrait
          ? const ScreenObjectSize(width: 720, height: 1280)
          : const ScreenObjectSize(width: 1280, height: 720);
    }
    return StreamBuilder<StreamSessionReadyState>(
      stream: _states,
      initialData: StreamSessionReadyState.closed,
      builder: (context, snapshot) {
        final state = snapshot.data ?? StreamSessionReadyState.closed;
        return ColoredBox(
          color: Colors.black,
          child: Stack(fit: StackFit.expand, children: [
            if (_session != null && _mixer?.screen != null)
              ScreenObjectEditorView(
                screen: _mixer!.screen!,
                videoGravity: VideoGravity.resizeAspectFill,
                child: StreamSessionViewTexture(_session,
                    key: ValueKey(_session!.memory),
                    videoGravity: VideoGravity.resizeAspectFill),
              )
            else
              SafeArea(
                  child: StudioStatePanel(
                title: context.studioText(
                    _initializing
                        ? 'Preparing camera…'
                        : 'Camera preview unavailable',
                    _initializing ? 'カメラを準備しています…' : 'カメラを準備できませんでした'),
                message: _error,
                loading: _initializing,
                onRetry: _initializing ? null : _initialize,
                onSettings: widget.onOpenSettings,
                onPermissions: _permissionDenied
                    ? () {
                        openAppSettings();
                      }
                    : null,
              )),
            if (_session != null) ...[
              Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Row(children: [
                            Expanded(
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: StudioStatus(state: state))),
                            const SizedBox(width: 12),
                            Material(
                                color: previewScrim,
                                shape: const CircleBorder(),
                                child: IconButton(
                                  tooltip: context.studioText(
                                      'Camera tools', 'カメラ調整'),
                                  onPressed:
                                      _changingCamera ? null : _showCameraTools,
                                  icon: const Icon(Icons.tune,
                                      color: Colors.white),
                                )),
                          ]),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            StudioError(
                                message: _error!,
                                onDismiss: () => setState(() => _error = null)),
                          ],
                        ]),
                      ))),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, previewScrim])),
                    child: SafeArea(
                        top: false,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                          child: Center(
                              child: StudioStreamAction(
                            state: state,
                            busy: _busy,
                            onPressed: () => _toggle(state),
                          )),
                        )),
                  )),
            ],
          ]),
        );
      },
    );
  }

  Future<void> _toggle(StreamSessionReadyState state) async {
    final session = _session;
    if (session == null || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      if (state == StreamSessionReadyState.open) {
        await session.close();
      } else {
        await session.connect();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error =
            error is StreamSessionException ? error.message : error.toString());
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showCameraTools() => showModalBottomSheet<void>(
        context: context,
        useSafeArea: true,
        isScrollControlled: true,
        showDragHandle: true,
        constraints: const BoxConstraints(maxWidth: 640),
        builder: (sheetContext) => StatefulBuilder(
            builder: (sheetContext, refreshSheet) => SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(children: [
                          Expanded(
                              child: Text(
                                  context.studioText('Camera tools', 'カメラ調整'),
                                  style:
                                      Theme.of(context).textTheme.titleLarge)),
                          IconButton(
                              onPressed: () => Navigator.pop(sheetContext),
                              tooltip: context.studioText(
                                  'Close camera tools', 'カメラ調整を閉じる'),
                              icon: const Icon(Icons.close)),
                        ]),
                        const SizedBox(height: 12),
                        for (final source in _videoSources)
                          ListTile(
                            title: Text(source.name ?? source.id),
                            leading: const Icon(Icons.videocam_outlined),
                            trailing: source.id == _mainVideoSource?.id
                                ? const Icon(Icons.check)
                                : null,
                            selected: source.id == _mainVideoSource?.id,
                            onTap: () {
                              Navigator.pop(sheetContext);
                              _selectCamera(source);
                            },
                          ),
                        if (_videoSources.length > 1)
                          SwitchListTile(
                            title: Text(
                                context.studioText('Second camera', '2台目のカメラ')),
                            subtitle: Text(context.studioText(
                                'Add another camera to the composition.',
                                '映像に別のカメラを重ねて表示します。')),
                            value: _secondaryCameraEnabled,
                            onChanged: _changingCamera
                                ? null
                                : (enabled) async {
                                    final operation = _setSecondCamera(enabled);
                                    refreshSheet(() {});
                                    await operation;
                                    if (sheetContext.mounted) {
                                      refreshSheet(() {});
                                    }
                                  },
                          ),
                        if (widget.onOpenSettings != null)
                          TextButton(
                            onPressed: () {
                              Navigator.pop(sheetContext);
                              widget.onOpenSettings!();
                            },
                            child: Text(context.studioText(
                                'Connection settings', '接続設定')),
                          ),
                      ]),
                )),
      );

  Future<void> _selectCamera(VideoSource source) async {
    final mixer = _mixer;
    if (mixer == null || _changingCamera || source.id == _mainVideoSource?.id) {
      return;
    }
    setState(() => _changingCamera = true);
    try {
      if (_secondaryCameraEnabled) await mixer.attachVideo(1, null);
      await mixer.attachVideo(0, source);
      if (_secondaryCameraEnabled) {
        await mixer.attachVideo(
            1, _videoSources.firstWhere((item) => item.id != source.id));
      }
      if (mounted) setState(() => _mainVideoSource = source);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _changingCamera = false);
    }
  }

  Future<void> _setSecondCamera(bool enabled) async {
    final mixer = _mixer;
    final main = _mainVideoSource;
    if (mixer == null || main == null || _changingCamera) return;
    setState(() => _changingCamera = true);
    try {
      final source = enabled
          ? _videoSources.firstWhere((item) => item.id != main.id)
          : null;
      await mixer.attachVideo(1, source);
      if (!mounted) return;
      if (enabled) {
        final video = VideoScreenObject()
          ..track = 1
          ..verticalAlignment = VerticalAlignment.top
          ..horizontalAlignment = HorizontalAlignment.right
          ..size = const ScreenObjectSize(width: 90, height: 160)
          ..layoutMargin = const ScreenObjectEdgeInsets(
              top: 16, left: 0, bottom: 0, right: 16);
        mixer.screen?.addChild(video);
        _secondaryVideoObject = video;
      } else {
        final video = _secondaryVideoObject;
        if (video != null) mixer.screen?.removeChild(video);
        _secondaryVideoObject = null;
      }
      setState(() => _secondaryCameraEnabled = enabled);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _changingCamera = false);
    }
  }

  Future<void> _initialize() async {
    if (_initializing || _session != null) return;
    _initializing = true;
    if (mounted) {
      setState(() {
        _error = null;
        _permissionDenied = false;
      });
    }
    MediaMixer? mixer;
    StreamSession? session;
    var transferred = false;
    try {
      if (!Platform.isMacOS) {
        final permissions =
            await [Permission.camera, Permission.microphone].request();
        if (permissions.values.any((status) => !status.isGranted)) {
          _permissionDenied = true;
          throw StateError(
              'Camera and microphone access are required. Allow access in app permissions, then try again.');
        }
      }
      final sources = await HaishinKitPlatformInterface.instance.videoSources;
      if (sources.isEmpty) throw StateError('No camera is available.');
      final audio = await AudioSession.instance;
      await audio.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth,
      ));
      mixer = await MediaMixer.create(
          options: const MediaMixerOptions(
              captureSessionMode: CaptureSessionMode.multi));
      final scheme = Uri.tryParse(Preference.shared.url)?.scheme;
      await mixer.attachAudio(
          0,
          AudioSource(
              sampleRate:
                  Platform.isAndroid && (scheme == 'http' || scheme == 'https')
                      ? 48000
                      : null));
      await mixer.attachVideo(0, sources.first);
      final text = TextScreenObject()
        ..value = 'by HaishinKit'
        ..verticalAlignment = VerticalAlignment.bottom
        ..horizontalAlignment = HorizontalAlignment.right
        ..layoutMargin =
            const ScreenObjectEdgeInsets(top: 0, left: 0, bottom: 60, right: 16)
        ..fontSize = 60;
      mixer.screen?.addChild(text);
      final image = ImageScreenObject()
        ..verticalAlignment = VerticalAlignment.top
        ..horizontalAlignment = HorizontalAlignment.left
        ..layoutMargin =
            const ScreenObjectEdgeInsets(top: 16, left: 16, bottom: 0, right: 0)
        ..size = const ScreenObjectSize(width: 120, height: 120);
      final data = await rootBundle.load('images/icon.png');
      image.setImage(ImageScreenObjectFormat.png, data.buffer);
      mixer.screen?.addChild(image);
      await mixer.startRunning();
      session = await StreamSession.create(
          Preference.shared.makeUrl(), StreamSessionMode.publish);
      if (!mounted) return;
      setState(() {
        _mixer = mixer;
        _session = session;
        _states = session!.readyState;
        _videoSources = sources;
        _mainVideoSource = sources.first;
      });
      transferred = true;
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (!transferred) await _release(session, mixer);
      if (mounted) setState(() => _initializing = false);
    }
  }
}
