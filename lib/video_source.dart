enum CameraPosition { front, back, unspecified }

class VideoSource {
  final String id;
  final String? name;
  final CameraPosition position;

//<editor-fold desc="Data Methods">

  VideoSource({
    required this.id,
    this.name,
    this.position = CameraPosition.unspecified,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VideoSource &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          position == other.position);

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ position.hashCode;

  @override
  String toString() {
    return 'VideoSource{id: $id, name: $name, position: $position}';
  }

  VideoSource copyWith({
    String? id,
    String? name,
    CameraPosition? position,
  }) {
    return VideoSource(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': position.name,
    };
  }

  factory VideoSource.fromMap(Map<String, dynamic> map) {
    return VideoSource(
      id: map['id'] as String,
      name: map['name'] as String?,
      position: map['position'] == null
          ? CameraPosition.unspecified
          : CameraPosition.values.byName(map['position'] as String),
    );
  }

//</editor-fold>
}
