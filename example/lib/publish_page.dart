import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit_example/preference.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:haishin_kit/haishin_kit.dart';

/// This is a sample page for publish sessions.
class PublishPage extends StatefulWidget {
  const PublishPage({super.key});

  @override
  State<StatefulWidget> createState() => _PublishState();
}

class _PublishState extends State<PublishPage> {
  MediaMixer? _mixer;
  StreamSession? _session;
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
              : StreamSessionViewTexture(_session),
        ),
        floatingActionButton: StreamBuilder<StreamSessionReadyState>(
            stream: _session?.readyState,
            initialData: StreamSessionReadyState.closed,
            builder: (context, shapshot) {
              switch (shapshot.data) {
                case StreamSessionReadyState.open:
                  return FloatingActionButton(
                    onPressed: _stopPublishing,
                    child: const Icon(Icons.stop_circle),
                  );
                case StreamSessionReadyState.closed:
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
    try {
      await _session?.connect();
    } on StreamSessionException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Session Error"),
            content: Text(e.message),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    }
  }

  void _stopPublishing() async {
    await _session?.close();
  }

  Future<void> _initPlatformState() async {
    if (Platform.isMacOS == false) {
      await Permission.camera.request();
      await Permission.microphone.request();
    }

    _videoSources = await HaishinKitPlatformInterface.instance.videoSources;
    _mainVideoSource = _videoSources.firstOrNull;

    // Set up AVAudioSession for iOS.
    final audioSession = await AudioSession.instance;
    await audioSession.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    final mixer = await MediaMixer.create();
    await mixer.startRunning();
    await mixer.attachAudio(0, AudioSource());
    await mixer.attachVideo(0, _mainVideoSource!);

    final text = TextScreenObject();
    text.value = "HaishinKit";
    text.verticalAlignment = VerticalAlignment.middle;
    text.horizontalAlignment = HorizontalAlignment.center;
    text.layoutMargin = ScreenObjectEdgeInsets(top: 0, left: 0, bottom: 60, right: 0);
    text.size = 60;
    mixer.screen?.addChild(text);

    StreamSession session = await StreamSession.create(
        Preference.shared.makeUrl(), StreamSessionMode.publish);

    setState(() {
      _mixer = mixer;
      _session = session;
    });
  }
}
