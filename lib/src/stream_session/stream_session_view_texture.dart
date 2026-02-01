import 'package:flutter/material.dart';

import 'stream_session.dart';

class StreamSessionViewTexture extends StatefulWidget {
  const StreamSessionViewTexture(this.session, {super.key});

  final StreamSession? session;

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
    final textureId = await widget.session?.updateTextureSize({
      "width": size.width,
      "height": size.height,
    });
    setState(() {
      _textureId = textureId;
    });
  }
}
