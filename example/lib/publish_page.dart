import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/session.dart';
import 'package:haishin_kit/session_mode.dart';
import 'package:haishin_kit/stream_view_texture.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:haishin_kit_example/preference.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:haishin_kit/media_mixer.dart';

/// This is a sample page for ingest RTMP streams.
class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<StatefulWidget> createState() => _PublishState();
}

class _PublishState extends State<PublishPage> {
  MediaMixer? _mixer;
  Session? _session;
  bool _publishing = false;
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
              : StreamViewTexture(_session),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _publish,
          child: _publishing
              ? const Icon(Icons.stop_circle)
              : const Icon(Icons.play_circle),
        ),
      ),
    );
  }

  void _publish() {
    if (_publishing) {
      _session?.close();
    } else {
      _session?.connect();
    }
    setState(() {
      if (_publishing) {
        _publishing = false;
      }
    });
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
    mixer.attachAudio(0, AudioSource());
    mixer.attachVideo(0, _mainVideoSource!);
    mixer.startRunning();

    Session session =
        await Session.create(Preference.shared.url, SessionMode.publish);

    setState(() {
      _mixer = mixer;
      _session = session;
    });
  }
}
