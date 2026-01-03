import 'package:flutter/services.dart';

/// Base exception type for all session-related errors.
///
/// This exception represents errors that occur while managing
/// a streaming session, such as connection failures or invalid states.
/// Platform-specific errors are mapped to subclasses of this type.
sealed class StreamSessionException implements Exception {
  final String message;

  const StreamSessionException(this.message);
}

/// Thrown when establishing a session connection fails.
///
/// This exception indicates that the session could not be connected,
/// for example due to network issues, authentication errors,
/// or server-side failures.
class StreamSessionConnectFailedException extends StreamSessionException {
  const StreamSessionConnectFailedException(super.message);
}

/// Thrown when an unexpected error occurs while handling a session.
///
/// This exception indicates that the session encountered an error
/// that is not explicitly modeled by other session exception types.
/// It may wrap platform-specific or internal errors, and should
/// generally be treated as non-recoverable unless otherwise specified.
class StreamSessionUnknownException extends StreamSessionException {
  const StreamSessionUnknownException(super.message);
}

