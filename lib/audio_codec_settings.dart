class AudioCodecSettings {
  int bitrate;

//<editor-fold desc="Data Methods">

  AudioCodecSettings({
    this.bitrate = 80 * 1000,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AudioCodecSettings &&
          runtimeType == other.runtimeType &&
          bitrate == other.bitrate);

  @override
  int get hashCode => bitrate.hashCode;

  @override
  String toString() {
    return 'AudioSettings{ bitrate: $bitrate,}';
  }

  AudioCodecSettings copyWith({
    bool? muted,
    int? bitrate,
  }) {
    return AudioCodecSettings(
      bitrate: bitrate ?? this.bitrate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bitrate': bitrate,
    };
  }

  factory AudioCodecSettings.fromMap(Map<String, dynamic> map) {
    return AudioCodecSettings(
      bitrate: map['bitrate'] as int,
    );
  }

//</editor-fold>
}
