import 'package:freezed_annotation/freezed_annotation.dart';

import 'screen_object_edge_insets.dart';
import 'screen_object_rect.dart';

part 'screen_object_snapshot.freezed.dart';

part 'screen_object_snapshot.g.dart';

@freezed
class ScreenObjectSnapshot with _$ScreenObjectSnapshot {
  const factory ScreenObjectSnapshot({
    required String type,
    required String id,
    required ScreenObjectRect frame,
    required ScreenObjectEdgeInsets layoutMargin,
    required int horizontalAlignment,
    required int verticalAlignment,
    required Map<String, String> elements,
    required List<ScreenObjectSnapshot> children,
  }) = _ScreenObjectSnapshot;

  factory ScreenObjectSnapshot.fromJson(Map<String, dynamic> json) =>
      _$ScreenObjectSnapshotFromJson(json);
}
