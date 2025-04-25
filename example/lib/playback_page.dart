import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/rtmp_connection.dart';
import 'package:haishin_kit/rtmp_stream.dart';
import 'package:haishin_kit/stream_view_texture.dart';
import 'package:haishin_kit_example/preference.dart';

/// This is a sample page for playing RTMP streams.
class PlaybackPage extends StatefulWidget {
  const PlaybackPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlaybackState();
}

class _PlaybackState extends State<PlaybackPage> {
  RtmpConnection? _connection;
  RtmpStream? _stream;

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
    _connection?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _stream == null
            ? const Text("Initialization")
            : StreamViewTexture(_stream),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _playback,
        child: _isPlaying
            ? const Icon(Icons.fiber_smart_record)
            : const Icon(Icons.not_started),
      ),
    );
  }

  void _playback() {
    setState(() {
      _connection?.connect(Preference.shared.url);
    });
  }

  Future<void> _initPlatformState() async {
    // Set up AVAudioSession for iOS.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playback,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    var connection = await RtmpConnection.create();
    connection.eventChannel.receiveBroadcastStream().listen((event) {
      switch (event["data"]["code"]) {
        case 'NetConnection.Connect.Success':
          _stream?.play(Preference.shared.streamName);
          setState(() {
            _isPlaying = true;
          });
          break;
      }
    });
    var stream = await RtmpStream.create(connection);

    setState(() {
      _connection = connection;
      _stream = stream;
    });
  }
}
