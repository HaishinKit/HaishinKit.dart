sealed class MediaMixerException implements Exception {
  final String message;

  const MediaMixerException(this.message);
}

class MediaMixerFailedToAttachException extends MediaMixerException {
  const MediaMixerFailedToAttachException(super.message);
}

class MediaMixerUnknownException extends MediaMixerException {
  const MediaMixerUnknownException(super.message);
}
