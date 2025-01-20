class LockAcquisitionException implements Exception {
  final String message;

  LockAcquisitionException(this.message);

  @override
  String toString() => 'LockAcquisitionException: $message';
}

class OpenException implements Exception {
  final String message;

  OpenException(this.message);

  @override
  String toString() => 'OpenException: $message';
}

class SecurityException implements Exception {
  final String message;

  SecurityException(this.message);

  @override
  String toString() => 'SecurityException: $message';
}

class ConnectionException implements Exception {
  final String message;

  ConnectionException(this.message);

  @override
  String toString() => 'ConnectionException: $message';
}

class SocketException implements Exception {
  final String message;

  SocketException(this.message);

  @override
  String toString() => 'SocketException: $message';
}
