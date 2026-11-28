import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart' show PlatformViewHitTestBehavior;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../haishin_kit/video_gravity.dart';
import '../media_mixer/dynamic_range_mode.dart';
import 'stream_session.dart';
import 'stream_session_view_texture.dart';

/// Displays a session with a texture for SDR or a native HDR surface for HLG.
///
/// HLG previews require iOS 16+ or Android 13+. Android uses hybrid composition
/// so 10-bit video does not pass through an 8-bit Flutter texture or virtual
/// display. Actual HDR brightness also depends on the device's display.
class StreamSessionView extends StatelessWidget {
  const StreamSessionView(
    this.session, {
    super.key,
    this.videoGravity = VideoGravity.resizeAspect,
  });

  final StreamSession? session;
  final VideoGravity videoGravity;

  @override
  Widget build(BuildContext context) {
    final current = session;
    if (current == null) return const SizedBox.expand();
    if (current.dynamicRangeMode == DynamicRangeMode.sdr) {
      return StreamSessionViewTexture(
        current,
        key: ValueKey(current.memory),
        videoGravity: videoGravity,
      );
    }
    const viewType = 'com.haishinkit.hdr';
    final parameters = <String, Object?>{
      'memory': current.memory,
      'videoGravity': videoGravity.name,
    };
    final nativeKey = ValueKey((current.memory, videoGravity));
    final direction = Directionality.maybeOf(context) ?? TextDirection.ltr;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
          key: nativeKey,
          viewType: viewType,
          surfaceFactory: (context, controller) => AndroidViewSurface(
            controller: controller as AndroidViewController,
            gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{},
            hitTestBehavior: PlatformViewHitTestBehavior.opaque,
          ),
          onCreatePlatformView: (parametersFromFlutter) {
            final controller = PlatformViewsService.initExpensiveAndroidView(
              id: parametersFromFlutter.id,
              viewType: viewType,
              layoutDirection: direction,
              creationParams: parameters,
              creationParamsCodec: const StandardMessageCodec(),
              onFocus: () => parametersFromFlutter.onFocusChanged(true),
            );
            controller.addOnPlatformViewCreatedListener(
              parametersFromFlutter.onPlatformViewCreated,
            );
            unawaited(controller.create());
            return controller;
          },
        );
      case TargetPlatform.iOS:
        return UiKitView(
          key: nativeKey,
          viewType: viewType,
          layoutDirection: direction,
          creationParams: parameters,
          creationParamsCodec: const StandardMessageCodec(),
        );
      default:
        throw UnsupportedError('HLG previews require iOS or Android.');
    }
  }
}
