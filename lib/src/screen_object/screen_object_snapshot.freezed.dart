// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_object_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScreenObjectSnapshot {

/// The type identifier of the screen object.
///
/// This value is used to determine how the object should be interpreted
/// or rendered (for example: `"image"`, `"text"`).
 String get type;/// The unique identifier of the screen object.
///
/// This ID is stable across snapshots and can be used to track the same
/// object over time.
 String get id;/// The requested width and height of the object.
 ScreenObjectSize get size;/// Whether the object is currently visible.
///
/// When `false`, the object should be ignored during rendering.
 bool get isVisible;/// The corner radius in composition pixels on Android.
 double get cornerRadius;/// The margin applied around the object during layout.
///
/// This value affects how the object is positioned relative to its
/// parent and siblings.
 ScreenObjectEdgeInsets get layoutMargin;/// The horizontal alignment of the object within its parent.
///
/// The value is represented as an integer and typically maps to
/// predefined alignment constants.
 int get horizontalAlignment;/// The vertical alignment of the object within its parent.
///
/// The value is represented as an integer and typically maps to
/// predefined alignment constants.
 int get verticalAlignment;/// A map of element-specific properties.
///
/// The contents of this map depend on the object [type]. For example,
/// an image object may store Base64-encoded bitmap data.
 Map<String, String> get elements;/// Child object snapshots.
///
/// This allows screen objects to form a hierarchical tree structure.
 List<ScreenObjectSnapshot> get children;
/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScreenObjectSnapshotCopyWith<ScreenObjectSnapshot> get copyWith => _$ScreenObjectSnapshotCopyWithImpl<ScreenObjectSnapshot>(this as ScreenObjectSnapshot, _$identity);

  /// Serializes this ScreenObjectSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScreenObjectSnapshot&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.size, size) || other.size == size)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.cornerRadius, cornerRadius) || other.cornerRadius == cornerRadius)&&(identical(other.layoutMargin, layoutMargin) || other.layoutMargin == layoutMargin)&&(identical(other.horizontalAlignment, horizontalAlignment) || other.horizontalAlignment == horizontalAlignment)&&(identical(other.verticalAlignment, verticalAlignment) || other.verticalAlignment == verticalAlignment)&&const DeepCollectionEquality().equals(other.elements, elements)&&const DeepCollectionEquality().equals(other.children, children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,size,isVisible,cornerRadius,layoutMargin,horizontalAlignment,verticalAlignment,const DeepCollectionEquality().hash(elements),const DeepCollectionEquality().hash(children));

@override
String toString() {
  return 'ScreenObjectSnapshot(type: $type, id: $id, size: $size, isVisible: $isVisible, cornerRadius: $cornerRadius, layoutMargin: $layoutMargin, horizontalAlignment: $horizontalAlignment, verticalAlignment: $verticalAlignment, elements: $elements, children: $children)';
}


}

/// @nodoc
abstract mixin class $ScreenObjectSnapshotCopyWith<$Res>  {
  factory $ScreenObjectSnapshotCopyWith(ScreenObjectSnapshot value, $Res Function(ScreenObjectSnapshot) _then) = _$ScreenObjectSnapshotCopyWithImpl;
@useResult
$Res call({
 String type, String id, ScreenObjectSize size, bool isVisible, double cornerRadius, ScreenObjectEdgeInsets layoutMargin, int horizontalAlignment, int verticalAlignment, Map<String, String> elements, List<ScreenObjectSnapshot> children
});


$ScreenObjectSizeCopyWith<$Res> get size;$ScreenObjectEdgeInsetsCopyWith<$Res> get layoutMargin;

}
/// @nodoc
class _$ScreenObjectSnapshotCopyWithImpl<$Res>
    implements $ScreenObjectSnapshotCopyWith<$Res> {
  _$ScreenObjectSnapshotCopyWithImpl(this._self, this._then);

  final ScreenObjectSnapshot _self;
  final $Res Function(ScreenObjectSnapshot) _then;

/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? id = null,Object? size = null,Object? isVisible = null,Object? cornerRadius = null,Object? layoutMargin = null,Object? horizontalAlignment = null,Object? verticalAlignment = null,Object? elements = null,Object? children = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as ScreenObjectSize,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,cornerRadius: null == cornerRadius ? _self.cornerRadius : cornerRadius // ignore: cast_nullable_to_non_nullable
as double,layoutMargin: null == layoutMargin ? _self.layoutMargin : layoutMargin // ignore: cast_nullable_to_non_nullable
as ScreenObjectEdgeInsets,horizontalAlignment: null == horizontalAlignment ? _self.horizontalAlignment : horizontalAlignment // ignore: cast_nullable_to_non_nullable
as int,verticalAlignment: null == verticalAlignment ? _self.verticalAlignment : verticalAlignment // ignore: cast_nullable_to_non_nullable
as int,elements: null == elements ? _self.elements : elements // ignore: cast_nullable_to_non_nullable
as Map<String, String>,children: null == children ? _self.children : children // ignore: cast_nullable_to_non_nullable
as List<ScreenObjectSnapshot>,
  ));
}
/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenObjectSizeCopyWith<$Res> get size {

  return $ScreenObjectSizeCopyWith<$Res>(_self.size, (value) {
    return _then(_self.copyWith(size: value));
  });
}/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenObjectEdgeInsetsCopyWith<$Res> get layoutMargin {

  return $ScreenObjectEdgeInsetsCopyWith<$Res>(_self.layoutMargin, (value) {
    return _then(_self.copyWith(layoutMargin: value));
  });
}
}


/// Adds pattern-matching-related methods to [ScreenObjectSnapshot].
extension ScreenObjectSnapshotPatterns on ScreenObjectSnapshot {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScreenObjectSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScreenObjectSnapshot() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScreenObjectSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ScreenObjectSnapshot():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScreenObjectSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ScreenObjectSnapshot() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String id,  ScreenObjectSize size,  bool isVisible,  double cornerRadius,  ScreenObjectEdgeInsets layoutMargin,  int horizontalAlignment,  int verticalAlignment,  Map<String, String> elements,  List<ScreenObjectSnapshot> children)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScreenObjectSnapshot() when $default != null:
return $default(_that.type,_that.id,_that.size,_that.isVisible,_that.cornerRadius,_that.layoutMargin,_that.horizontalAlignment,_that.verticalAlignment,_that.elements,_that.children);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String id,  ScreenObjectSize size,  bool isVisible,  double cornerRadius,  ScreenObjectEdgeInsets layoutMargin,  int horizontalAlignment,  int verticalAlignment,  Map<String, String> elements,  List<ScreenObjectSnapshot> children)  $default,) {final _that = this;
switch (_that) {
case _ScreenObjectSnapshot():
return $default(_that.type,_that.id,_that.size,_that.isVisible,_that.cornerRadius,_that.layoutMargin,_that.horizontalAlignment,_that.verticalAlignment,_that.elements,_that.children);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String id,  ScreenObjectSize size,  bool isVisible,  double cornerRadius,  ScreenObjectEdgeInsets layoutMargin,  int horizontalAlignment,  int verticalAlignment,  Map<String, String> elements,  List<ScreenObjectSnapshot> children)?  $default,) {final _that = this;
switch (_that) {
case _ScreenObjectSnapshot() when $default != null:
return $default(_that.type,_that.id,_that.size,_that.isVisible,_that.cornerRadius,_that.layoutMargin,_that.horizontalAlignment,_that.verticalAlignment,_that.elements,_that.children);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScreenObjectSnapshot implements ScreenObjectSnapshot {
  const _ScreenObjectSnapshot({required this.type, required this.id, required this.size, required this.isVisible, this.cornerRadius = 0.0, required this.layoutMargin, required this.horizontalAlignment, required this.verticalAlignment, required final  Map<String, String> elements, required final  List<ScreenObjectSnapshot> children}): _elements = elements,_children = children;
  factory _ScreenObjectSnapshot.fromJson(Map<String, dynamic> json) => _$ScreenObjectSnapshotFromJson(json);

/// The type identifier of the screen object.
///
/// This value is used to determine how the object should be interpreted
/// or rendered (for example: `"image"`, `"text"`).
@override final  String type;
/// The unique identifier of the screen object.
///
/// This ID is stable across snapshots and can be used to track the same
/// object over time.
@override final  String id;
/// The requested width and height of the object.
@override final  ScreenObjectSize size;
/// Whether the object is currently visible.
///
/// When `false`, the object should be ignored during rendering.
@override final  bool isVisible;
/// The corner radius in composition pixels on Android.
@override@JsonKey() final  double cornerRadius;
/// The margin applied around the object during layout.
///
/// This value affects how the object is positioned relative to its
/// parent and siblings.
@override final  ScreenObjectEdgeInsets layoutMargin;
/// The horizontal alignment of the object within its parent.
///
/// The value is represented as an integer and typically maps to
/// predefined alignment constants.
@override final  int horizontalAlignment;
/// The vertical alignment of the object within its parent.
///
/// The value is represented as an integer and typically maps to
/// predefined alignment constants.
@override final  int verticalAlignment;
/// A map of element-specific properties.
///
/// The contents of this map depend on the object [type]. For example,
/// an image object may store Base64-encoded bitmap data.
 final  Map<String, String> _elements;
/// A map of element-specific properties.
///
/// The contents of this map depend on the object [type]. For example,
/// an image object may store Base64-encoded bitmap data.
@override Map<String, String> get elements {
  if (_elements is EqualUnmodifiableMapView) return _elements;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_elements);
}

/// Child object snapshots.
///
/// This allows screen objects to form a hierarchical tree structure.
 final  List<ScreenObjectSnapshot> _children;
/// Child object snapshots.
///
/// This allows screen objects to form a hierarchical tree structure.
@override List<ScreenObjectSnapshot> get children {
  if (_children is EqualUnmodifiableListView) return _children;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_children);
}


/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScreenObjectSnapshotCopyWith<_ScreenObjectSnapshot> get copyWith => __$ScreenObjectSnapshotCopyWithImpl<_ScreenObjectSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScreenObjectSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScreenObjectSnapshot&&(identical(other.type, type) || other.type == type)&&(identical(other.id, id) || other.id == id)&&(identical(other.size, size) || other.size == size)&&(identical(other.isVisible, isVisible) || other.isVisible == isVisible)&&(identical(other.cornerRadius, cornerRadius) || other.cornerRadius == cornerRadius)&&(identical(other.layoutMargin, layoutMargin) || other.layoutMargin == layoutMargin)&&(identical(other.horizontalAlignment, horizontalAlignment) || other.horizontalAlignment == horizontalAlignment)&&(identical(other.verticalAlignment, verticalAlignment) || other.verticalAlignment == verticalAlignment)&&const DeepCollectionEquality().equals(other._elements, _elements)&&const DeepCollectionEquality().equals(other._children, _children));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,id,size,isVisible,cornerRadius,layoutMargin,horizontalAlignment,verticalAlignment,const DeepCollectionEquality().hash(_elements),const DeepCollectionEquality().hash(_children));

@override
String toString() {
  return 'ScreenObjectSnapshot(type: $type, id: $id, size: $size, isVisible: $isVisible, cornerRadius: $cornerRadius, layoutMargin: $layoutMargin, horizontalAlignment: $horizontalAlignment, verticalAlignment: $verticalAlignment, elements: $elements, children: $children)';
}


}

/// @nodoc
abstract mixin class _$ScreenObjectSnapshotCopyWith<$Res> implements $ScreenObjectSnapshotCopyWith<$Res> {
  factory _$ScreenObjectSnapshotCopyWith(_ScreenObjectSnapshot value, $Res Function(_ScreenObjectSnapshot) _then) = __$ScreenObjectSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String type, String id, ScreenObjectSize size, bool isVisible, double cornerRadius, ScreenObjectEdgeInsets layoutMargin, int horizontalAlignment, int verticalAlignment, Map<String, String> elements, List<ScreenObjectSnapshot> children
});


@override $ScreenObjectSizeCopyWith<$Res> get size;@override $ScreenObjectEdgeInsetsCopyWith<$Res> get layoutMargin;

}
/// @nodoc
class __$ScreenObjectSnapshotCopyWithImpl<$Res>
    implements _$ScreenObjectSnapshotCopyWith<$Res> {
  __$ScreenObjectSnapshotCopyWithImpl(this._self, this._then);

  final _ScreenObjectSnapshot _self;
  final $Res Function(_ScreenObjectSnapshot) _then;

/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? id = null,Object? size = null,Object? isVisible = null,Object? cornerRadius = null,Object? layoutMargin = null,Object? horizontalAlignment = null,Object? verticalAlignment = null,Object? elements = null,Object? children = null,}) {
  return _then(_ScreenObjectSnapshot(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,size: null == size ? _self.size : size // ignore: cast_nullable_to_non_nullable
as ScreenObjectSize,isVisible: null == isVisible ? _self.isVisible : isVisible // ignore: cast_nullable_to_non_nullable
as bool,cornerRadius: null == cornerRadius ? _self.cornerRadius : cornerRadius // ignore: cast_nullable_to_non_nullable
as double,layoutMargin: null == layoutMargin ? _self.layoutMargin : layoutMargin // ignore: cast_nullable_to_non_nullable
as ScreenObjectEdgeInsets,horizontalAlignment: null == horizontalAlignment ? _self.horizontalAlignment : horizontalAlignment // ignore: cast_nullable_to_non_nullable
as int,verticalAlignment: null == verticalAlignment ? _self.verticalAlignment : verticalAlignment // ignore: cast_nullable_to_non_nullable
as int,elements: null == elements ? _self._elements : elements // ignore: cast_nullable_to_non_nullable
as Map<String, String>,children: null == children ? _self._children : children // ignore: cast_nullable_to_non_nullable
as List<ScreenObjectSnapshot>,
  ));
}

/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenObjectSizeCopyWith<$Res> get size {

  return $ScreenObjectSizeCopyWith<$Res>(_self.size, (value) {
    return _then(_self.copyWith(size: value));
  });
}/// Create a copy of ScreenObjectSnapshot
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ScreenObjectEdgeInsetsCopyWith<$Res> get layoutMargin {

  return $ScreenObjectEdgeInsetsCopyWith<$Res>(_self.layoutMargin, (value) {
    return _then(_self.copyWith(layoutMargin: value));
  });
}
}

// dart format on
