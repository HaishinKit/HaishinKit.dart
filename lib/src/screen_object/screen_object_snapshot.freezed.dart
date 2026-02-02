// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_object_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScreenObjectSnapshot _$ScreenObjectSnapshotFromJson(Map<String, dynamic> json) {
  return _ScreenObjectSnapshot.fromJson(json);
}

/// @nodoc
mixin _$ScreenObjectSnapshot {
  String get type => throw _privateConstructorUsedError;
  String get id => throw _privateConstructorUsedError;
  ScreenObjectRect get frame => throw _privateConstructorUsedError;
  ScreenObjectEdgeInsets get layoutMargin => throw _privateConstructorUsedError;
  int get horizontalAlignment => throw _privateConstructorUsedError;
  int get verticalAlignment => throw _privateConstructorUsedError;
  Map<String, String> get elements => throw _privateConstructorUsedError;
  List<ScreenObjectSnapshot> get children => throw _privateConstructorUsedError;

  /// Serializes this ScreenObjectSnapshot to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScreenObjectSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScreenObjectSnapshotCopyWith<ScreenObjectSnapshot> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScreenObjectSnapshotCopyWith<$Res> {
  factory $ScreenObjectSnapshotCopyWith(ScreenObjectSnapshot value,
          $Res Function(ScreenObjectSnapshot) then) =
      _$ScreenObjectSnapshotCopyWithImpl<$Res, ScreenObjectSnapshot>;
  @useResult
  $Res call(
      {String type,
      String id,
      ScreenObjectRect frame,
      ScreenObjectEdgeInsets layoutMargin,
      int horizontalAlignment,
      int verticalAlignment,
      Map<String, String> elements,
      List<ScreenObjectSnapshot> children});

  $ScreenObjectRectCopyWith<$Res> get frame;
  $ScreenObjectEdgeInsetsCopyWith<$Res> get layoutMargin;
}

/// @nodoc
class _$ScreenObjectSnapshotCopyWithImpl<$Res,
        $Val extends ScreenObjectSnapshot>
    implements $ScreenObjectSnapshotCopyWith<$Res> {
  _$ScreenObjectSnapshotCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScreenObjectSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? frame = null,
    Object? layoutMargin = null,
    Object? horizontalAlignment = null,
    Object? verticalAlignment = null,
    Object? elements = null,
    Object? children = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      frame: null == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as ScreenObjectRect,
      layoutMargin: null == layoutMargin
          ? _value.layoutMargin
          : layoutMargin // ignore: cast_nullable_to_non_nullable
              as ScreenObjectEdgeInsets,
      horizontalAlignment: null == horizontalAlignment
          ? _value.horizontalAlignment
          : horizontalAlignment // ignore: cast_nullable_to_non_nullable
              as int,
      verticalAlignment: null == verticalAlignment
          ? _value.verticalAlignment
          : verticalAlignment // ignore: cast_nullable_to_non_nullable
              as int,
      elements: null == elements
          ? _value.elements
          : elements // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      children: null == children
          ? _value.children
          : children // ignore: cast_nullable_to_non_nullable
              as List<ScreenObjectSnapshot>,
    ) as $Val);
  }

  /// Create a copy of ScreenObjectSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScreenObjectRectCopyWith<$Res> get frame {
    return $ScreenObjectRectCopyWith<$Res>(_value.frame, (value) {
      return _then(_value.copyWith(frame: value) as $Val);
    });
  }

  /// Create a copy of ScreenObjectSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScreenObjectEdgeInsetsCopyWith<$Res> get layoutMargin {
    return $ScreenObjectEdgeInsetsCopyWith<$Res>(_value.layoutMargin, (value) {
      return _then(_value.copyWith(layoutMargin: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ScreenObjectSnapshotImplCopyWith<$Res>
    implements $ScreenObjectSnapshotCopyWith<$Res> {
  factory _$$ScreenObjectSnapshotImplCopyWith(_$ScreenObjectSnapshotImpl value,
          $Res Function(_$ScreenObjectSnapshotImpl) then) =
      __$$ScreenObjectSnapshotImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String type,
      String id,
      ScreenObjectRect frame,
      ScreenObjectEdgeInsets layoutMargin,
      int horizontalAlignment,
      int verticalAlignment,
      Map<String, String> elements,
      List<ScreenObjectSnapshot> children});

  @override
  $ScreenObjectRectCopyWith<$Res> get frame;
  @override
  $ScreenObjectEdgeInsetsCopyWith<$Res> get layoutMargin;
}

/// @nodoc
class __$$ScreenObjectSnapshotImplCopyWithImpl<$Res>
    extends _$ScreenObjectSnapshotCopyWithImpl<$Res, _$ScreenObjectSnapshotImpl>
    implements _$$ScreenObjectSnapshotImplCopyWith<$Res> {
  __$$ScreenObjectSnapshotImplCopyWithImpl(_$ScreenObjectSnapshotImpl _value,
      $Res Function(_$ScreenObjectSnapshotImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScreenObjectSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? id = null,
    Object? frame = null,
    Object? layoutMargin = null,
    Object? horizontalAlignment = null,
    Object? verticalAlignment = null,
    Object? elements = null,
    Object? children = null,
  }) {
    return _then(_$ScreenObjectSnapshotImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      frame: null == frame
          ? _value.frame
          : frame // ignore: cast_nullable_to_non_nullable
              as ScreenObjectRect,
      layoutMargin: null == layoutMargin
          ? _value.layoutMargin
          : layoutMargin // ignore: cast_nullable_to_non_nullable
              as ScreenObjectEdgeInsets,
      horizontalAlignment: null == horizontalAlignment
          ? _value.horizontalAlignment
          : horizontalAlignment // ignore: cast_nullable_to_non_nullable
              as int,
      verticalAlignment: null == verticalAlignment
          ? _value.verticalAlignment
          : verticalAlignment // ignore: cast_nullable_to_non_nullable
              as int,
      elements: null == elements
          ? _value._elements
          : elements // ignore: cast_nullable_to_non_nullable
              as Map<String, String>,
      children: null == children
          ? _value._children
          : children // ignore: cast_nullable_to_non_nullable
              as List<ScreenObjectSnapshot>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScreenObjectSnapshotImpl implements _ScreenObjectSnapshot {
  const _$ScreenObjectSnapshotImpl(
      {required this.type,
      required this.id,
      required this.frame,
      required this.layoutMargin,
      required this.horizontalAlignment,
      required this.verticalAlignment,
      required final Map<String, String> elements,
      required final List<ScreenObjectSnapshot> children})
      : _elements = elements,
        _children = children;

  factory _$ScreenObjectSnapshotImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScreenObjectSnapshotImplFromJson(json);

  @override
  final String type;
  @override
  final String id;
  @override
  final ScreenObjectRect frame;
  @override
  final ScreenObjectEdgeInsets layoutMargin;
  @override
  final int horizontalAlignment;
  @override
  final int verticalAlignment;
  final Map<String, String> _elements;
  @override
  Map<String, String> get elements {
    if (_elements is EqualUnmodifiableMapView) return _elements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_elements);
  }

  final List<ScreenObjectSnapshot> _children;
  @override
  List<ScreenObjectSnapshot> get children {
    if (_children is EqualUnmodifiableListView) return _children;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_children);
  }

  @override
  String toString() {
    return 'ScreenObjectSnapshot(type: $type, id: $id, frame: $frame, layoutMargin: $layoutMargin, horizontalAlignment: $horizontalAlignment, verticalAlignment: $verticalAlignment, elements: $elements, children: $children)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScreenObjectSnapshotImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.frame, frame) || other.frame == frame) &&
            (identical(other.layoutMargin, layoutMargin) ||
                other.layoutMargin == layoutMargin) &&
            (identical(other.horizontalAlignment, horizontalAlignment) ||
                other.horizontalAlignment == horizontalAlignment) &&
            (identical(other.verticalAlignment, verticalAlignment) ||
                other.verticalAlignment == verticalAlignment) &&
            const DeepCollectionEquality().equals(other._elements, _elements) &&
            const DeepCollectionEquality().equals(other._children, _children));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      type,
      id,
      frame,
      layoutMargin,
      horizontalAlignment,
      verticalAlignment,
      const DeepCollectionEquality().hash(_elements),
      const DeepCollectionEquality().hash(_children));

  /// Create a copy of ScreenObjectSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScreenObjectSnapshotImplCopyWith<_$ScreenObjectSnapshotImpl>
      get copyWith =>
          __$$ScreenObjectSnapshotImplCopyWithImpl<_$ScreenObjectSnapshotImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ScreenObjectSnapshotImplToJson(
      this,
    );
  }
}

abstract class _ScreenObjectSnapshot implements ScreenObjectSnapshot {
  const factory _ScreenObjectSnapshot(
          {required final String type,
          required final String id,
          required final ScreenObjectRect frame,
          required final ScreenObjectEdgeInsets layoutMargin,
          required final int horizontalAlignment,
          required final int verticalAlignment,
          required final Map<String, String> elements,
          required final List<ScreenObjectSnapshot> children}) =
      _$ScreenObjectSnapshotImpl;

  factory _ScreenObjectSnapshot.fromJson(Map<String, dynamic> json) =
      _$ScreenObjectSnapshotImpl.fromJson;

  @override
  String get type;
  @override
  String get id;
  @override
  ScreenObjectRect get frame;
  @override
  ScreenObjectEdgeInsets get layoutMargin;
  @override
  int get horizontalAlignment;
  @override
  int get verticalAlignment;
  @override
  Map<String, String> get elements;
  @override
  List<ScreenObjectSnapshot> get children;

  /// Create a copy of ScreenObjectSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScreenObjectSnapshotImplCopyWith<_$ScreenObjectSnapshotImpl>
      get copyWith => throw _privateConstructorUsedError;
}
