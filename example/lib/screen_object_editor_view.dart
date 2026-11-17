import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:haishin_kit/haishin_kit.dart';

class ScreenObjectEditorView extends StatefulWidget {
  final Screen screen;
  final Widget child;
  final VideoGravity videoGravity;

  const ScreenObjectEditorView({
    super.key,
    required this.screen,
    required this.child,
    this.videoGravity = VideoGravity.resizeAspect,
  });

  @override
  State<ScreenObjectEditorView> createState() => _ScreenObjectEditorViewState();
}

class _ScreenObjectEditorViewState extends State<ScreenObjectEditorView> {
  late ScreenObjectEditor _editor;
  Timer? _timer;
  bool _refreshing = false;
  ScreenObject? _selected;
  Offset? _previous;
  ScreenObject? _gestureTarget;
  int _pointerCount = 0;
  double _previousScale = 1;
  bool _transforming = false;
  bool _dialogOpen = false;

  @override
  void initState() {
    super.initState();
    _editor = ScreenObjectEditor(widget.screen);
    _timer =
        Timer.periodic(const Duration(milliseconds: 60), (_) => _refresh());
    _refresh();
  }

  @override
  void didUpdateWidget(covariant ScreenObjectEditorView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screen != widget.screen) {
      _editor = ScreenObjectEditor(widget.screen);
      _selected = null;
    }
  }

  Future<void> _refresh() async {
    if (_refreshing || _transforming) return;
    _refreshing = true;
    try {
      final editor = _editor;
      await editor.refresh();
      if (mounted && editor == _editor) setState(() {});
    } on PlatformException catch (error) {
      debugPrint('Could not read overlay layout: ${error.message}');
    } finally {
      _refreshing = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  ScreenCoordinateTransform _coordinates(Size size) =>
      ScreenCoordinateTransform(
          screenSize: _editor.size,
          previewSize: size,
          videoGravity: widget.videoGravity);

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        final size = constraints.biggest;
        final coordinates = _coordinates(size);
        final bounds = _selected == null ? null : _editor.boundsOf(_selected!);
        final projected =
            bounds == null ? null : coordinates.rectToPreview(bounds);
        final rect = projected?.intersect(Offset.zero & size);
        return Stack(clipBehavior: Clip.hardEdge, children: [
          Positioned.fill(child: widget.child),
          Positioned.fill(
              child: Listener(
            onPointerSignal: (event) {
              if (event is! PointerScrollEvent || _transforming) return;
              final point = coordinates.toScreen(event.localPosition);
              final target = point == null ? null : _editor.hitTest(point);
              if (target == null) return;
              GestureBinding.instance.pointerSignalResolver.register(event,
                  (_) {
                setState(() {
                  _selected = target;
                  _editor.transform(target,
                      anchor: point!,
                      scale:
                          math.exp((-event.scrollDelta.dy * .01).clamp(-2, 2)));
                });
              });
            },
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: (details) async {
                final point = coordinates.toScreen(details.localPosition);
                if (point == null ||
                    !(Offset.zero & _editor.size).contains(point)) {
                  return;
                }
                final target = _editor.hitTest(point);
                setState(() => _selected = target);
                if (target is TextScreenObject) {
                  await _editText(target);
                } else if (target == null) {
                  await _add(point);
                }
              },
              onScaleStart: (details) {
                _transforming = true;
                _previous = coordinates.toScreen(details.localFocalPoint);
                _previousScale = 1;
                _pointerCount = details.pointerCount;
                final target =
                    _previous == null ? null : _editor.hitTest(_previous!);
                _gestureTarget =
                    target ?? (details.pointerCount > 1 ? _selected : null);
                if (_gestureTarget != null) {
                  setState(() => _selected = _gestureTarget);
                }
              },
              onScaleUpdate: (details) {
                final point = coordinates.toScreen(details.localFocalPoint);
                if (details.pointerCount != _pointerCount) {
                  _pointerCount = details.pointerCount;
                  _previous = point;
                  _previousScale = details.scale;
                  return;
                }
                if (_gestureTarget != null &&
                    point != null &&
                    _previous != null) {
                  setState(() => _editor.transform(_gestureTarget!,
                      anchor: _previous!,
                      destination: point,
                      scale: details.scale / _previousScale));
                }
                _previous = point;
                _previousScale = details.scale;
              },
              onScaleEnd: (_) {
                _previous = null;
                _gestureTarget = null;
                _transforming = false;
                _refresh();
              },
            ),
          )),
          if (rect != null && !rect.isEmpty) ...[
            Positioned.fromRect(
                rect: rect,
                child: IgnorePointer(
                    child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2)),
                ))),
            Positioned(
              left:
                  (rect.right - 24).clamp(0.0, math.max(0.0, size.width - 48)),
              top: (rect.top - 24).clamp(0.0, math.max(0.0, size.height - 48)),
              child: IconButton(
                tooltip: 'Delete object',
                onPressed: () => setState(() {
                  widget.screen.removeChild(_selected!);
                  _selected = null;
                }),
                icon: Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black38, blurRadius: 3)
                      ]),
                  child: const Icon(Icons.close, color: Colors.black, size: 16),
                ),
              ),
            ),
            if (Theme.of(context).platform == TargetPlatform.macOS)
              Positioned(
                left: (rect.center.dx - 48)
                    .clamp(0.0, math.max(0.0, size.width - 96)),
                top: (rect.bottom + 4)
                    .clamp(0.0, math.max(0.0, size.height - 48)),
                child: Row(children: [
                  _resizeButton(Icons.remove, 1 / 1.2),
                  _resizeButton(Icons.add, 1.2),
                ]),
              ),
          ],
        ]);
      });

  Widget _resizeButton(IconData icon, double scale) => IconButton(
        tooltip: scale > 1 ? 'Enlarge object' : 'Shrink object',
        icon: Icon(icon, color: Colors.black, size: 16),
        style: IconButton.styleFrom(backgroundColor: Colors.white),
        onPressed: () {
          final selected = _selected;
          final bounds = selected == null ? null : _editor.boundsOf(selected);
          if (selected == null || bounds == null) return;
          setState(() =>
              _editor.transform(selected, anchor: bounds.center, scale: scale));
        },
      );

  Future<void> _add(Offset position) async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    try {
      final kind = await showDialog<String>(
          context: context,
          builder: (context) => SimpleDialog(
                title: const Text('Add object'),
                children: ['Text', 'Sample image', 'Camera overlay']
                    .map((kind) => SimpleDialogOption(
                          onPressed: () => Navigator.pop(context, kind),
                          child: Text(kind),
                        ))
                    .toList(),
              ));
      if (!mounted || kind == null) return;
      final ScreenObject object;
      switch (kind) {
        case 'Text':
          object = TextScreenObject()
            ..value = 'New text'
            ..fontSize = 60;
        case 'Sample image':
          final data = await rootBundle.load('images/icon.png');
          if (!mounted) return;
          object = ImageScreenObject()
            ..size = const ScreenObjectSize(width: 160, height: 160)
            ..setImage(ImageScreenObjectFormat.png, data.buffer);
        default:
          object = VideoScreenObject()
            ..track = 0
            ..size = const ScreenObjectSize(width: 180, height: 120);
      }
      _editor.place(object, position);
      widget.screen.addChild(object);
      setState(() => _selected = object);
      await _refresh();
    } finally {
      _dialogOpen = false;
    }
  }

  Future<void> _editText(TextScreenObject target) async {
    if (_dialogOpen) return;
    _dialogOpen = true;
    final input = TextEditingController(text: target.value);
    try {
      final value = await showDialog<String>(
          context: context,
          builder: (context) => StatefulBuilder(
              builder: (context, rebuild) => AlertDialog(
                    title: const Text('Edit text'),
                    content: TextField(
                        controller: input,
                        autofocus: true,
                        minLines: 2,
                        maxLines: 6,
                        onChanged: (_) => rebuild(() {})),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel')),
                      TextButton(
                          onPressed: input.text.trim().isEmpty
                              ? null
                              : () => Navigator.pop(context, input.text),
                          child: const Text('Save')),
                    ],
                  )));
      if (mounted && value != null && target.parent == widget.screen) {
        target.updateLayout(() {
          target.size = const ScreenObjectSize(width: 0, height: 0);
          target.value = value;
        });
        _editor.invalidateBounds(target);
        await _refresh();
      }
    } finally {
      input.dispose();
      _dialogOpen = false;
    }
  }
}
