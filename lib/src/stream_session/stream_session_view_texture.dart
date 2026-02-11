import 'dart:convert' as convert;

import 'package:flutter/material.dart';
import 'stream_session_view_texture_snapshot.dart';

import 'stream_session.dart';
import '../haishin_kit/video_gravity.dart';

/// A Flutter widget that renders a native video texture provided by a
/// [StreamSession].
///
/// This widget displays video frames using Flutter's [Texture] widget,
/// where the underlying texture is registered and managed by the native
/// platform (iOS/Android).
///
/// The scaling behavior of the video inside its layout bounds is controlled
/// by [videoGravity]. The actual scaling is applied on the native side.
class StreamSessionViewTexture extends StatefulWidget {
  /// Creates a widget that renders the video texture associated with
  /// the given [StreamSession].
  ///
  /// If [session] is null, no texture will be rendered.
  ///
  /// The [videoGravity] parameter controls how the video content is scaled
  /// within its container. By default, the video preserves its aspect ratio
  /// and fits entirely within the view (`resizeAspect`).
  const StreamSessionViewTexture(
    this.session, {
    super.key,
    this.videoGravity = VideoGravity.resizeAspect,
  });

  /// The streaming session responsible for registering and updating
  /// the underlying native texture.
  ///
  /// This object typically manages communication with the platform side
  /// and provides texture lifecycle control.
  final StreamSession? session;

  /// Controls how the video is resized or scaled within the widget bounds.
  ///
  /// This value is forwarded to the native layer, where the actual scaling
  /// behavior is applied (e.g., AVLayerVideoGravity on iOS or Matrix scaling
  /// on Android).
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
      return Container(
        color: Colors.black,
      );
    }

    return Texture(textureId: _textureId!);
  }

  Future<void> _updatePlatformState(Size size) async {
    StreamSessionViewTextureSnapshot snapshot =
        StreamSessionViewTextureSnapshot(
            width: size.width,
            height: size.height,
            videoGravity: widget.videoGravity);
    final textureId = await widget.session?.updateTexture({
      "value": convert.json.encode(snapshot.toJson()),
    });
    setState(() {
      _textureId = textureId;
    });
  }
}
