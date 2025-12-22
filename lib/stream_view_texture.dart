import 'package:flutter/material.dart';
import 'package:haishin_kit/session.dart';

class StreamViewTexture extends StatefulWidget {
  const StreamViewTexture(this.session, {super.key});

  final Session? session;

  @override
  State<StatefulWidget> createState() => _StreamViewTextureState();
}

class _StreamViewTextureState extends State<StreamViewTexture> with WidgetsBindingObserver {
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
