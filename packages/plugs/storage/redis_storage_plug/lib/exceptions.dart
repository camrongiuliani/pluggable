/// Exception thrown when a lock cannot be acquired in Redis.
///
/// This typically occurs when trying to acquire a lock that is already held
/// by another process or when the Redis server is unavailable.
///
/// Example:
/// ```dart
/// try {
///   await acquireLock();
/// } catch (e) {
///   if (e is LockAcquisitionException) {
///     // Handle lock acquisition failure
///   }
/// }
/// ```
class LockAcquisitionException implements Exception {
  /// The error message describing why the lock could not be acquired.
  final String message;

  /// Creates a new [LockAcquisitionException] with the given [message].
  LockAcquisitionException(this.message);

  @override
  String toString() => 'LockAcquisitionException: $message';
}

/// Exception thrown when there is an error opening a Redis connection or cache.
///
/// This can occur due to invalid configuration, authentication failures,
/// or other connection-related issues.
///
/// Example:
/// ```dart
/// try {
///   await storage.open<String>(expiry: Duration(hours: 1));
/// } catch (e) {
///   if (e is OpenException) {
///     // Handle open failure
///   }
/// }
/// ```
class OpenException implements Exception {
  /// The error message describing why the open operation failed.
  final String message;

  /// Creates a new [OpenException] with the given [message].
  OpenException(this.message);

  @override
  String toString() => 'OpenException: $message';
}

/// Exception thrown when there is a security-related error in Redis operations.
///
/// This can occur due to authentication failures, permission issues,
/// or other security-related problems.
///
/// Example:
/// ```dart
/// try {
///   await storage.put('key', 'value');
/// } catch (e) {
///   if (e is SecurityException) {
///     // Handle security error
///   }
/// }
/// ```
class SecurityException implements Exception {
  /// The error message describing the security issue.
  final String message;

  /// Creates a new [SecurityException] with the given [message].
  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}

/// Exception thrown when there is a connection error with the Redis server.
///
/// This can occur when the Redis server is unreachable, the connection is lost,
/// or there are network issues.
///
/// Example:
/// ```dart
/// try {
///   await storage.get<String>('key');
/// } catch (e) {
///   if (e is ConnectionException) {
///     // Handle connection error
///   }
/// }
/// ```
class ConnectionException implements Exception {
  /// The error message describing the connection issue.
  final String message;

  /// Creates a new [ConnectionException] with the given [message].
  ConnectionException(this.message);

  @override
  String toString() => 'ConnectionException: $message';
}

/// Exception thrown when there is a socket-related error in Redis operations.
///
/// This can occur due to network issues, socket timeouts, or other
/// socket-related problems.
///
/// Example:
/// ```dart
/// try {
///   await storage.put('key', 'value');
/// } catch (e) {
///   if (e is SocketException) {
///     // Handle socket error
///   }
/// }
/// ```
class SocketException implements Exception {
  /// The error message describing the socket issue.
  final String message;

  /// Creates a new [SocketException] with the given [message].
  SocketException(this.message);

  @override
  String toString() => 'SocketException: $message';
}
