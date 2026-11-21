import 'dart:async';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:haishin_kit/haishin_kit.dart';

import 'preference.dart';
import 'studio_theme.dart';
import 'studio_widgets.dart';

class PlaybackPage extends StatefulWidget {
  const PlaybackPage({super.key, this.onOpenSettings});

  final VoidCallback? onOpenSettings;

  @override
  State<PlaybackPage> createState() => _PlaybackState();
}

class _PlaybackState extends State<PlaybackPage> {
  StreamSession? _session;
  Stream<StreamSessionReadyState>? _states;
  bool _initializing = false;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    unawaited(_release(_session));
    super.dispose();
  }

  Future<void> _release(StreamSession? session) async {
    try {
      await session?.dispose();
    } catch (error) {
      debugPrint('Could not release playback: $error');
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<StreamSessionReadyState>(
        stream: _states,
        initialData: StreamSessionReadyState.closed,
        builder: (context, snapshot) {
          final state = snapshot.data ?? StreamSessionReadyState.closed;
          return ColoredBox(
              color: Colors.black,
              child: Stack(fit: StackFit.expand, children: [
                if (_session != null)
                  StreamSessionViewTexture(_session,
                      key: ValueKey(_session!.memory)),
                SafeArea(
                    child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    Row(children: [
                      Expanded(
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child:
                                  StudioStatus(state: state, playback: true))),
                      const SizedBox(width: 12),
                      IconButton.filledTonal(
                          onPressed: widget.onOpenSettings,
                          tooltip: context.studioText('Settings', '設定'),
                          icon: const Icon(Icons.settings_outlined)),
                    ]),
                    Expanded(
                        child: state == StreamSessionReadyState.open &&
                                _error == null
                            ? const SizedBox.expand()
                            : StudioStatePanel(
                                title: context.studioText(
                                    _initializing
                                        ? 'Preparing stream…'
                                        : _error != null
                                            ? 'Couldn’t play the stream'
                                            : 'Your stream appears here',
                                    _initializing
                                        ? 'ストリームを準備しています…'
                                        : _error != null
                                            ? 'ストリームを再生できませんでした'
                                            : 'ここに映像が表示されます'),
                                message: _error ??
                                    context.studioText(
                                        'Set a connection in Settings, then tap Play stream.',
                                        '設定で接続先を入力し、ストリームを再生してください。'),
                                loading: _initializing,
                                onRetry: _session == null && !_initializing
                                    ? _initialize
                                    : null,
                                onSettings: widget.onOpenSettings,
                              )),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, previewScrim])),
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: StudioStreamAction(
                          state: state,
                          busy: _busy,
                          playback: true,
                          onPressed:
                              _session == null ? null : () => _toggle(state)),
                    ),
                  ]),
                )),
              ]));
        },
      );

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

  Future<void> _initialize() async {
    if (_initializing || _session != null) return;
    setState(() {
      _initializing = true;
      _error = null;
    });
    StreamSession? session;
    try {
      final audio = await AudioSession.instance;
      await audio.configure(const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth,
      ));
      session = await StreamSession.create(
          Preference.shared.makeUrl(), StreamSessionMode.playback);
      if (!mounted) {
        await _release(session);
        return;
      }
      setState(() {
        _session = session;
        _states = session!.readyState;
      });
    } catch (error) {
      await _release(session);
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _initializing = false);
    }
  }
}
