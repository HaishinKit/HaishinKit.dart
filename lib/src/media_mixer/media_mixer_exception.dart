sealed class MediaMixerException implements Exception {
  final String message;

  const MediaMixerException(this.message);
}

class MediaMixerUnknownException extends MediaMixerException {
  const MediaMixerUnknownException(super.message);
}
