import 'package:flutter/material.dart';
import 'package:haishin_kit/haishin_kit.dart';

import 'studio_theme.dart';

class StudioSection extends StatelessWidget {
  const StudioSection(
      {super.key, required this.title, this.description, required this.child});

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Semantics(
                header: true,
                child: Text(title,
                    style: Theme.of(context).textTheme.titleMedium)),
            if (description != null) ...[
              const SizedBox(height: 8),
              Text(description!,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
            const SizedBox(height: 20),
            child,
          ]),
        ),
      );
}

class StudioStatus extends StatelessWidget {
  const StudioStatus({super.key, required this.state, this.playback = false});

  final StreamSessionReadyState state;
  final bool playback;

  @override
  Widget build(BuildContext context) {
    final label = switch (state) {
      StreamSessionReadyState.open => context.studioText('Connected', '接続中'),
      StreamSessionReadyState.connecting =>
        context.studioText('Connecting…', '接続しています…'),
      StreamSessionReadyState.closing =>
        context.studioText('Stopping…', '停止しています…'),
      StreamSessionReadyState.closed => playback
          ? context.studioText('Not connected', '未接続')
          : context.studioText('Preview only', 'プレビューのみ'),
    };
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: previewScrim, borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(label, style: const TextStyle(color: Colors.white))),
      ),
    );
  }
}

class StudioError extends StatelessWidget {
  const StudioError(
      {super.key, required this.message, required this.onDismiss});

  final String message;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) => Semantics(
        liveRegion: true,
        child: Material(
          color: Theme.of(context).colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 4),
            child: Row(children: [
              Expanded(
                  child: Text(message,
                      style: TextStyle(
                          color:
                              Theme.of(context).colorScheme.onErrorContainer))),
              IconButton(
                  onPressed: onDismiss,
                  tooltip: context.studioText('Dismiss error', 'エラー表示を閉じる'),
                  icon: const Icon(Icons.close)),
            ]),
          ),
        ),
      );
}

class StudioStreamAction extends StatelessWidget {
  const StudioStreamAction(
      {super.key,
      required this.state,
      required this.onPressed,
      this.busy = false,
      this.playback = false});

  final StreamSessionReadyState state;
  final VoidCallback? onPressed;
  final bool busy;
  final bool playback;

  @override
  Widget build(BuildContext context) {
    final active = state == StreamSessionReadyState.open;
    final waiting = busy ||
        state == StreamSessionReadyState.connecting ||
        state == StreamSessionReadyState.closing;
    final label = waiting
        ? context.studioText('Please wait…', '処理しています…')
        : active
            ? context.studioText('Stop stream', 'ストリームを停止')
            : playback
                ? context.studioText('Play stream', 'ストリームを再生')
                : context.studioText('Go live', '配信開始');
    final colors = Theme.of(context).colorScheme;
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox.square(
        dimension: 72,
        child: FilledButton(
          onPressed: waiting ? null : onPressed,
          style: FilledButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const CircleBorder(),
            backgroundColor: active ? colors.errorContainer : colors.primary,
            foregroundColor:
                active ? colors.onErrorContainer : colors.onPrimary,
          ),
          child: waiting
              ? SizedBox.square(
                  dimension: 24,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, semanticsLabel: label))
              : Icon(active ? Icons.stop : Icons.play_arrow,
                  size: 32, semanticLabel: label),
        ),
      ),
      const SizedBox(height: 6),
      ExcludeSemantics(
          child: Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white))),
    ]);
  }
}

class StudioStatePanel extends StatelessWidget {
  const StudioStatePanel(
      {super.key,
      required this.title,
      this.message,
      this.loading = false,
      this.onRetry,
      this.onSettings,
      this.onPermissions});

  final String title;
  final String? message;
  final bool loading;
  final VoidCallback? onPermissions;
  final VoidCallback? onRetry;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: StudioSection(
                title: title,
                description: message,
                child: Wrap(spacing: 12, runSpacing: 12, children: [
                  if (loading) const CircularProgressIndicator(),
                  if (onPermissions != null)
                    OutlinedButton(
                        onPressed: onPermissions,
                        child: Text(
                            context.studioText('App permissions', 'アプリの権限設定'))),
                  if (onRetry != null)
                    OutlinedButton(
                        onPressed: onRetry,
                        child: Text(context.studioText('Try again', 'もう一度試す'))),
                  if (onSettings != null)
                    TextButton(
                        onPressed: onSettings,
                        child: Text(context.studioText('Settings', '設定'))),
                ])),
          ),
        ),
      );
}
