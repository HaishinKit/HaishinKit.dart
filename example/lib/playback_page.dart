import 'package:flutter/material.dart';
import 'package:haishin_kit/session.dart';
import 'package:haishin_kit/stream_view_texture.dart';

/// This is a sample page for playing RTMP streams.
class PlaybackPage extends StatefulWidget {
  const PlaybackPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlaybackState();
}

class _PlaybackState extends State<PlaybackPage> {
  Session? _session;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _session?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: _session == null
              ? const Text("Initialization")
              : StreamViewTexture(_session)),
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
      _session?.close();
    } else {
      _session?.connect();
    }
    setState(() {
      if (_isPlaying) {
        _isPlaying = false;
      }
    });
  }
}
