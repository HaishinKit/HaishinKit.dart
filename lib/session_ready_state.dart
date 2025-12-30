/// Represents the current connection state of a session.
enum SessionReadyState {
  /// The session is currently attempting to establish a connection.
  connecting,

  /// The session has been successfully established and is ready for communication.
  open,

  /// The session is in the process of closing the connection.
  closing,

  /// The session has been closed or could not be established.
  closed
}
