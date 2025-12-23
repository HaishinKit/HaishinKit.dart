import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/audio_source.dart';
import 'package:haishin_kit/haishin_kit_platform_interface.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream.dart';
import 'package:haishin_kit/stream_view_texture.dart';
import 'package:haishin_kit/video_source.dart';
import 'package:haishin_kit_example/preference.dart';
import 'package:permission_handler/permission_handler.dart';

/// This is a sample page for ingest RTMP streams.
class IngestPage extends StatefulWidget {
  const IngestPage({super.key});

  @override
  State<StatefulWidget> createState() => _IngestState();
}

class _IngestState extends State<IngestPage> {
  RtmpConnection? _connection;
  RtmpStream? _stream;
  bool _ingesting = false;
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
    _connection?.dispose();
    _stream?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: null, actions: [
          DropdownMenu<VideoSource>(
            initialSelection: _mainVideoSource,
            onSelected: (value) {
              _stream?.attachVideo(value, 0);
              setState(() {
                _mainVideoSource = value;
              });
            },
            dropdownMenuEntries: _videoSourceEntries,
          ),
        ]),
        body: Center(
          child: _stream == null
              ? const Text("Initialization")
              : StreamViewTexture(_stream),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _ingest,
          child: _ingesting
              ? const Icon(Icons.stop_circle)
              : const Icon(Icons.play_circle),
        ),
      ),
    );
  }

  void _ingest() {
    if (_ingesting) {
      _connection?.close();
    } else {
      _connection?.connect(Preference.shared.url);
    }
    setState(() {
      if (_ingesting) {
        _ingesting = false;
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
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    RtmpConnection connection = await RtmpConnection.create();
    connection.eventChannel.receiveBroadcastStream().listen((event) {
      switch (event["data"]["code"]) {
        case 'NetConnection.Connect.Success':
          _stream?.publish(Preference.shared.streamName);
          setState(() {
            _ingesting = true;
          });
          break;
      }
    });
    RtmpStream stream = await RtmpStream.create(connection);
    stream.attachAudio(AudioSource());
    stream.attachVideo(_mainVideoSource!, 0);

    setState(() {
      _connection = connection;
      _stream = stream;
    });
  }
}
