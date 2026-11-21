import 'package:flutter/material.dart';

import 'preference.dart';
import 'studio_theme.dart';
import 'studio_widgets.dart';

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => PreferenceState();
}

class PreferenceState extends State<PreferencePage> {
  late String _url = Preference.shared.url;

  bool get _rtmp => ['rtmp', 'rtmps']
      .contains(Uri.tryParse(_url.trim())?.scheme.toLowerCase());

  bool _validUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        ['rtmp', 'rtmps', 'srt', 'http', 'https']
            .contains(uri.scheme.toLowerCase()) &&
        (uri.scheme == 'srt' || uri.host.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.all(20),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                Semantics(
                    header: true,
                    child: Text(context.studioText('Settings', '設定'),
                        style: Theme.of(context).textTheme.headlineMedium)),
                const SizedBox(height: 8),
                Text(
                    context.studioText(
                        'Set up your next stream.', '次の配信の準備をしましょう。'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
                const SizedBox(height: 24),
                StudioSection(
                  title: context.studioText('Connection', '接続先'),
                  description: context.studioText(
                      'Changes apply when you reopen Publish or Playback. Settings are kept for this app session.',
                      '変更は配信・再生画面を開き直すと反映されます。設定はアプリを終了するまで保持されます。'),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            key: const ValueKey('stream-url'),
                            initialValue: _url,
                            decoration: InputDecoration(
                                labelText: context.studioText(
                                    'Stream URL', 'ストリームURL'),
                                helperText: context.studioText(
                                    'Use RTMP, SRT, or a complete WHIP/WHEP endpoint.',
                                    'RTMP・SRT、またはWHIP/WHEPの完全な接続先を入力します。'),
                                helperMaxLines: 4),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            enableSuggestions: false,
                            validator: (value) => _validUrl(value ?? '')
                                ? null
                                : context.studioText(
                                    'Enter a supported URL with a host.',
                                    '対応する形式とホスト名を含むURLを入力してください。'),
                            onChanged: (value) {
                              Preference.shared.url = value.trim();
                              setState(() => _url = value);
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            key: const ValueKey('stream-name'),
                            initialValue: Preference.shared.streamName,
                            enabled: _rtmp,
                            decoration: InputDecoration(
                                labelText: context.studioText(
                                    'RTMP stream name', 'RTMPストリーム名'),
                                helperText: context.studioText(
                                    'Used only for RTMP/RTMPS.',
                                    'RTMP・RTMPSでのみ使用します。'),
                                helperMaxLines: 2),
                            textInputAction: TextInputAction.done,
                            autocorrect: false,
                            onChanged: (value) =>
                                Preference.shared.streamName = value,
                          ),
                        ]),
                  ),
                ),
                const SizedBox(height: 24),
                StudioSection(
                  title: context.studioText('Using the example', 'サンプルの使い方'),
                  description: context.studioText(
                      'Publish sends camera and microphone media. Playback receives a stream. A reachable streaming server is required.',
                      '配信ではカメラとマイクの映像・音声を送り、再生ではストリームを受信します。接続できる配信サーバーが必要です。'),
                  child: Text(context.studioText(
                      'For WHIP and WHEP, enter the endpoint for the mode you want to use. The RTMP stream name is not appended to HTTP(S) or SRT URLs.',
                      'WHIP・WHEPでは、使用するモードの接続先を入力します。HTTP(S)・SRTのURLにはRTMPストリーム名は追加されません。')),
                ),
              ],
            ),
          ),
        ),
      );
}
