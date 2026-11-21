/// Selects the default audio input for capture.
class AudioSource {
  /// Requests a microphone capture rate on Android, in Hz.
  final int? sampleRate;

  AudioSource({this.sampleRate});

  Map<String, dynamic> toMap() {
    return {if (sampleRate != null) 'sampleRate': sampleRate};
  }
}
