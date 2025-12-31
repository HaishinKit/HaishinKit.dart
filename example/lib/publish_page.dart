import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/screen_settings.dart';
import 'package:haishin_kit/session.dart';
import 'package:haishin_kit/session_mode.dart';
import 'package:haishin_kit/session_ready_state.dart';
import 'package:haishin_kit/session_view_texture.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:haishin_kit_example/preference.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:haishin_kit/media_mixer.dart';

/// This is a sample page for publish RTMP streams.
class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<StatefulWidget> createState() => _PublishState();
}

class _PublishState extends State<PublishPage> {
  MediaMixer? _mixer;
  Session? _session;
  CameraPosition currentPosition = CameraPosition.back;
  List<VideoSource> _videoSources = [];
  VideoSource? _mainVideoSource;

  List<DropdownMenuEntry<VideoSource>> get _videoSourceEntries => _videoSources
      .map((e) => DropdownMenuEntry(label: e.name ?? e.id, value: e))
      .toList();

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    _mixer?.dispose();
    _session?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.portrait) {
      _mixer?.screenSettings = ScreenSettings(
        width: 720,
        height: 1280,
      );
    } else {
      _mixer?.screenSettings = ScreenSettings(
        width: 1280,
        height: 720,
      );
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: null, actions: [
          DropdownMenu<VideoSource>(
            initialSelection: _mainVideoSource,
            onSelected: (value) {
              _mixer?.attachVideo(0, value);
              setState(() {
                _mainVideoSource = value;
              });
            },
            dropdownMenuEntries: _videoSourceEntries,
          ),
        ]),
        body: Center(
          child: _session == null
              ? const Text("Initialization")
              : SessionViewTexture(_session),
        ),
        floatingActionButton: StreamBuilder<SessionReadyState>(
            stream: _session?.readyState,
            initialData: SessionReadyState.closed,
            builder: (context, shapshot) {
              switch (shapshot.data) {
                case SessionReadyState.open:
                  return FloatingActionButton(
                    onPressed: _stopPublishing,
                    child: const Icon(Icons.stop_circle),
                  );
                case SessionReadyState.closed:
                  return FloatingActionButton(
                    onPressed: _startPublishing,
                    child: const Icon(Icons.play_circle),
                  );
                default:
                  return const SizedBox.shrink();
              }
            }),
      ),
    );
  }

  void _startPublishing() async {
    await _session?.connect();
  }

  void _stopPublishing() async {
    await _session?.close();
  }

  Future<void> _initPlatformState() async {
    if (Platform.isMacOS == false) {
      await Permission.camera.request();
      await Permission.microphone.request();
    }

    _videoSources = await HaishinKitPlatform.instance.videoSources;
    _mainVideoSource = _videoSources.firstOrNull;

    // Set up AVAudioSession for iOS.
    final audioSession = await AudioSession.instance;
    await audioSession.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    MediaMixer mixer = await MediaMixer.create();
    await mixer.attachAudio(0, AudioSource());
    await mixer.attachVideo(0, _mainVideoSource!);
    await mixer.startRunning();

    Session session =
        await Session.create(Preference.shared.makeUrl(), SessionMode.publish);

    setState(() {
      _mixer = mixer;
      _session = session;
    });
  }
}
