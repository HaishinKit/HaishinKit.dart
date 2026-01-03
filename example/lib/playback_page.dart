import 'package:flutter/material.dart';
import 'package:haishin_kit/stream_session.dart';
import 'package:haishin_kit/stream_session_mode.dart';
import 'package:haishin_kit/stream_session_ready_state.dart';
import 'package:haishin_kit/stream_session_view_texture.dart';
import 'package:haishin_kit_example/preference.dart';
import 'package:audio_session/audio_session.dart';

/// This is a sample page for playing RTMP streams.
class PlaybackPage extends StatefulWidget {
  const PlaybackPage({super.key});

  @override
  State<StatefulWidget> createState() => _PlaybackState();
}

class _PlaybackState extends State<PlaybackPage> {
  StreamSession? _session;

  @override
  void initState() {
    super.initState();
    _initPlatformState();
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
              : StreamSessionViewTexture(_session)),
      floatingActionButton: StreamBuilder<StreamSessionReadyState>(
          stream: _session?.readyState,
          initialData: StreamSessionReadyState.closed,
          builder: (context, shapshot) {
            switch (shapshot.data) {
              case StreamSessionReadyState.open:
                return FloatingActionButton(
                  onPressed: _stopPlaying,
                  child: const Icon(Icons.stop_circle),
                );
              case StreamSessionReadyState.closed:
                return FloatingActionButton(
                  onPressed: _startPlaying,
                  child: const Icon(Icons.play_circle),
                );
              default:
                return const SizedBox.shrink();
            }
          }),
    );
  }

  void _startPlaying() async {
    await _session?.connect();
  }

  void _stopPlaying() async {
    await _session?.close();
  }

  Future<void> _initPlatformState() async {
    // Set up AVAudioSession for iOS.
    final audioSession = await AudioSession.instance;
    await audioSession.configure(const AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth,
    ));

    StreamSession session =
        await StreamSession.create(Preference.shared.makeUrl(), SessionMode.playback);

    setState(() {
      _session = session;
    });
  }
}
