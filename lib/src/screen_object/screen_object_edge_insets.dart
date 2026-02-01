import 'package:freezed_annotation/freezed_annotation.dart';

part 'screen_object_edge_insets.freezed.dart';

part 'screen_object_edge_insets.g.dart';

@freezed
class ScreenObjectEdgeInsets with _$ScreenObjectEdgeInsets {
  const factory ScreenObjectEdgeInsets({
    required int top,
    required int left,
    required int bottom,
    required int right,
  }) = _ScreenObjectEdgeInsets;

  factory ScreenObjectEdgeInsets.fromJson(Map<String, dynamic> json) =>
      _$ScreenObjectEdgeInsetsFromJson(json);
}
