/// Represents the type of session to establish.
enum StreamSessionMode {
  /// A publishing session, used to stream media from the local device to a server or peers.
  publish,

  /// A playback session, used to receive and play media streamed from a server or peers.
  playback
}
