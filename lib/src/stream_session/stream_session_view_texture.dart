import 'dart:convert' as convert;

import 'package:flutter/widgets.dart';
import 'stream_session_view_texture_snapshot.dart';

import 'stream_session.dart';
import '../haishin_kit/video_gravity.dart';

/// Displays an SDR video texture from a [StreamSession].
///
/// Use `StreamSessionView` for HLG sessions to preserve HDR in a native surface.
class StreamSessionViewTexture extends StatefulWidget {
  /// Displays video from [session], or an empty view when [session] is null.
  ///
  /// By default, [videoGravity] fits the entire video inside the view while
  /// preserving its aspect ratio.
  const StreamSessionViewTexture(
    this.session, {
    super.key,
    this.videoGravity = VideoGravity.resizeAspect,
  });

  /// The session that provides the video texture.
  final StreamSession? session;

  /// How the video fits within the widget's bounds.
  final VideoGravity videoGravity;

  @override
  State<StatefulWidget> createState() => _StreamSessionViewTextureState();
}

class _StreamSessionViewTextureState extends State<StreamSessionViewTexture>
    with WidgetsBindingObserver {
  int? _textureId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initPlatformState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlatformState(context.size!);
    });
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlatformState(context.size!);
    });
  }

  @override
  void didUpdateWidget(covariant StreamSessionViewTexture oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.videoGravity != widget.videoGravity) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _updatePlatformState(context.size!);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Future<void> initPlatformState() async {
    int? textureId = await widget.session?.registerTexture({});
    setState(() {
      _textureId = textureId;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_textureId == null) {
      return Container(color: const Color(0xFF000000));
    }

    return Texture(textureId: _textureId!);
  }

  Future<void> _updatePlatformState(Size size) async {
    StreamSessionViewTextureSnapshot snapshot =
        StreamSessionViewTextureSnapshot(
          width: size.width,
          height: size.height,
          videoGravity: widget.videoGravity,
        );
    final textureId = await widget.session?.updateTexture({
      "value": convert.json.encode(snapshot.toJson()),
    });
    setState(() {
      _textureId = textureId;
    });
  }
}
