import 'dart:io';

import 'package:haishin_kit/haishin_kit.dart';
import 'package:material_ui/material_ui.dart';

import 'preference.dart';
import 'publishing_codecs.dart';
import 'studio_theme.dart';
import 'studio_widgets.dart';

enum _CodecIssue { noHlgEncoder, readFailed }

class PreferencePage extends StatefulWidget {
  const PreferencePage({super.key});

  @override
  State<PreferencePage> createState() => PreferenceState();
}

class PreferenceState extends State<PreferencePage> {
  late String _url = Preference.shared.url;
  List<VideoCodec> _encoders = [];
  bool _checkingCodecs = true;
  _CodecIssue? _codecError;
  int _codecRequest = 0;
  DynamicRangeMode? _requestedRange;
  DynamicRangeMode? _failedRange;

  List<VideoCodec> get _codecs => publishingCodecs(
    _url,
    _encoders,
    android: Platform.isAndroid,
    range: Preference.shared.dynamicRangeMode,
  );

  @override
  void initState() {
    super.initState();
    _loadCodecs(Preference.shared.dynamicRangeMode);
  }

  void _chooseSupportedCodec() {
    final codecs = _codecs;
    if (codecs.isNotEmpty && !codecs.contains(Preference.shared.videoCodec)) {
      Preference.shared.videoCodec = codecs.first;
    }
  }

  Future<void> _loadCodecs(DynamicRangeMode range) async {
    final request = ++_codecRequest;
    _requestedRange = range;
    setState(() {
      _checkingCodecs = true;
      _codecError = null;
      _failedRange = null;
    });
    try {
      final encoders = await HaishinKitPlatformInterface.instance
          .supportedVideoCodecs(dynamicRangeMode: range);
      if (!mounted || request != _codecRequest) return;
      setState(() {
        if (range == DynamicRangeMode.hlg && encoders.isEmpty) {
          _codecError = _CodecIssue.noHlgEncoder;
          _failedRange = range;
        } else {
          Preference.shared.dynamicRangeMode = range;
          _encoders = encoders;
          _chooseSupportedCodec();
        }
      });
    } catch (_) {
      if (!mounted || request != _codecRequest) return;
      setState(() {
        _codecError = _CodecIssue.readFailed;
        _failedRange = range;
      });
    } finally {
      if (mounted && request == _codecRequest) {
        setState(() {
          _checkingCodecs = false;
          _requestedRange = null;
        });
      }
    }
  }

  bool get _rtmp => [
    'rtmp',
    'rtmps',
  ].contains(Uri.tryParse(_url.trim())?.scheme.toLowerCase());

  bool _validUrl(String value) {
    final uri = Uri.tryParse(value.trim());
    return uri != null &&
        [
          'rtmp',
          'rtmps',
          'srt',
          'http',
          'https',
        ].contains(uri.scheme.toLowerCase()) &&
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
              child: Text(
                context.studioText('Settings', '設定'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              context.studioText('Set up your next stream.', '次の配信の準備をしましょう。'),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            StudioSection(
              title: context.studioText('Connection', '接続先'),
              description: context.studioText(
                'Changes apply when you reopen Publish or Playback. Settings are kept for this app session.',
                '変更は配信・再生画面を開き直すと反映されます。設定はアプリを終了するまで保持されます。',
              ),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      key: const ValueKey('stream-url'),
                      initialValue: _url,
                      decoration: InputDecoration(
                        labelText: context.studioText('Stream URL', 'ストリームURL'),
                        helperText: context.studioText(
                          'Use RTMP, SRT, or a complete WHIP/WHEP endpoint.',
                          'RTMP・SRT、またはWHIP/WHEPの完全な接続先を入力します。',
                        ),
                        helperMaxLines: 4,
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      validator: (value) => _validUrl(value ?? '')
                          ? null
                          : context.studioText(
                              'Enter a supported URL with a host.',
                              '対応する形式とホスト名を含むURLを入力してください。',
                            ),
                      onChanged: (value) {
                        Preference.shared.url = value.trim();
                        setState(() {
                          _url = value;
                          _chooseSupportedCodec();
                        });
                        final scheme = Uri.tryParse(value.trim())?.scheme
                            .toLowerCase();
                        if (const ['srt', 'http', 'https'].contains(scheme) &&
                            (Preference.shared.dynamicRangeMode ==
                                    DynamicRangeMode.hlg ||
                                _requestedRange == DynamicRangeMode.hlg ||
                                _failedRange == DynamicRangeMode.hlg)) {
                          Preference.shared.dynamicRangeMode =
                              DynamicRangeMode.sdr;
                          _loadCodecs(DynamicRangeMode.sdr);
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const ValueKey('stream-name'),
                      initialValue: Preference.shared.streamName,
                      enabled: _rtmp,
                      decoration: InputDecoration(
                        labelText: context.studioText(
                          'RTMP stream name',
                          'RTMPストリーム名',
                        ),
                        helperText: context.studioText(
                          'Used only for RTMP/RTMPS.',
                          'RTMP・RTMPSでのみ使用します。',
                        ),
                        helperMaxLines: 2,
                      ),
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      onChanged: (value) =>
                          Preference.shared.streamName = value,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            StudioSection(
              title: context.studioText('Video', '映像'),
              description: context.studioText(
                'Choose an OS encoder for this device and URL. Your server must support the selected codec.',
                '端末とURLに合うOS搭載エンコーダーを選択します。サーバー側も選択したコーデックへの対応が必要です。',
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_checkingCodecs)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        children: [
                          const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              context.studioText(
                                'Checking device codecs…',
                                '端末のコーデックを確認しています…',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  DropdownButtonFormField<VideoCodec>(
                    key: ValueKey(
                      'video-codec-${Uri.tryParse(_url)?.scheme}-${Preference.shared.dynamicRangeMode.name}-${_codecs.join()}',
                    ),
                    initialValue: _codecs.contains(Preference.shared.videoCodec)
                        ? Preference.shared.videoCodec
                        : null,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: context.studioText(
                        'Publishing codec',
                        '配信コーデック',
                      ),
                    ),
                    items: _codecs
                        .map(
                          (codec) => DropdownMenuItem(
                            value: codec,
                            child: Text(videoCodecLabel(codec)),
                          ),
                        )
                        .toList(),
                    onChanged: _checkingCodecs || _codecs.isEmpty
                        ? null
                        : (codec) {
                            if (codec != null)
                              setState(
                                () => Preference.shared.videoCodec = codec,
                              );
                          },
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile.adaptive(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('HLG HDR'),
                    subtitle: Text(
                      context.studioText(
                        'RTMP only. Requires a compatible camera, encoder and display. Also selects HDR playback.',
                        'RTMPで使用できます。対応するカメラ・エンコーダー・画面が必要です。HDR再生にも適用されます。',
                      ),
                    ),
                    value:
                        Preference.shared.dynamicRangeMode ==
                        DynamicRangeMode.hlg,
                    onChanged: !_rtmp || _checkingCodecs
                        ? null
                        : (value) => _loadCodecs(
                            value ? DynamicRangeMode.hlg : DynamicRangeMode.sdr,
                          ),
                  ),
                  if (_codecError != null) ...[
                    Text(
                      _codecError == _CodecIssue.noHlgEncoder
                          ? context.studioText(
                              'HLG encoding is unavailable on this device.',
                              'この端末ではHLGをエンコードできません。',
                            )
                          : context.studioText(
                              'Could not read device codecs. Try again.',
                              '端末のコーデックを確認できませんでした。再試行してください。',
                            ),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: _checkingCodecs
                            ? null
                            : () => _loadCodecs(
                                !_rtmp && _failedRange == DynamicRangeMode.hlg
                                    ? DynamicRangeMode.sdr
                                    : _failedRange ??
                                          Preference.shared.dynamicRangeMode,
                              ),
                        icon: const Icon(Icons.refresh),
                        label: Text(context.studioText('Check again', '再確認')),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            StudioSection(
              title: context.studioText('Using the example', 'サンプルの使い方'),
              description: context.studioText(
                'Publish sends camera and microphone media. Playback receives a stream. A reachable streaming server is required.',
                '配信ではカメラとマイクの映像・音声を送り、再生ではストリームを受信します。接続できる配信サーバーが必要です。',
              ),
              child: Text(
                context.studioText(
                  'For WHIP and WHEP, enter the endpoint for the mode you want to use. The RTMP stream name is not appended to HTTP(S) or SRT URLs.',
                  'WHIP・WHEPでは、使用するモードの接続先を入力します。HTTP(S)・SRTのURLにはRTMPストリーム名は追加されません。',
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
