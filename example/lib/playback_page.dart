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
    _stream?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _stream == null
              ? const Text("Initialization")
              : StreamViewTexture(_stream)),
      floatingActionButton: FloatingActionButton(
        onPressed: _playback,
        child: _isPlaying
            ? const Icon(Icons.stop_circle)
            : const Icon(Icons.play_circle),
      ),
    );
  }

  void _playback() {
    if (_isPlaying) {
      _connection?.close();
    } else {
      _connection?.connect(Preference.shared.url);
    }
    setState(() {
      if (_isPlaying) {
        _isPlaying = false;
      }
    });
  }

  Future<void> _initPlatformState() async {
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
