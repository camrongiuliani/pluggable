/// HTTP status codes and exceptions for the Pluggable system.
/// 
/// This file contains constants for HTTP status codes and exception classes
/// for handling HTTP-related errors.
/// 
/// Example usage:
/// ```dart
/// // Check status code
/// if (response.statusCode == PHttpStatusCode.ok) {
///   // Handle successful response
/// }
/// 
/// // Throw an exception
/// if (userNotFound) {
///   throw NotFoundException();
/// }
/// ```

/// Abstract class containing HTTP status code constants
abstract class PHttpStatusCode {
  // 1xx Informational
  /// Continue
  static const int continue_ = 100;

  /// Switching Protocols
  static const int switchingProtocols = 101;

  /// Processing
  static const int processing = 102;

  /// Early Hints
  static const int earlyHints = 103;

  // 2xx Success
  /// OK
  static const int ok = 200;

  /// Created
  static const int created = 201;

  /// Accepted
  static const int accepted = 202;

  /// Non-Authoritative Information
  static const int nonAuthoritativeInformation = 203;

  /// No Content
  static const int noContent = 204;

  /// Reset Content
  static const int resetContent = 205;

  /// Partial Content
  static const int partialContent = 206;

  /// Multi-Status
  static const int multiStatus = 207;

  /// Already Reported
  static const int alreadyReported = 208;

  /// IM Used
  static const int imUsed = 226;

  // 3xx Redirection
  /// Multiple Choices
  static const int multipleChoices = 300;

  /// Moved Permanently
  static const int movedPermanently = 301;

  /// Found
  static const int found = 302;

  /// Moved Temporarily (alias for Found)
  static const int movedTemporarily = 302;

  /// See Other
  static const int seeOther = 303;

  /// Not Modified
  static const int notModified = 304;

  /// Use Proxy
  static const int useProxy = 305;

  /// Temporary Redirect
  static const int temporaryRedirect = 307;

  /// Permanent Redirect
  static const int permanentRedirect = 308;

  // 4xx Client Error
  /// Bad Request
  static const int badRequest = 400;

  /// Unauthorized
  static const int unauthorized = 401;

  /// Payment Required
  static const int paymentRequired = 402;

  /// Forbidden
  static const int forbidden = 403;

  /// Not Found
  static const int notFound = 404;

  /// Method Not Allowed
  static const int methodNotAllowed = 405;

  /// Not Acceptable
  static const int notAcceptable = 406;

  /// Proxy Authentication Required
  static const int proxyAuthenticationRequired = 407;

  /// Request Timeout
  static const int requestTimeout = 408;

  /// Conflict
  static const int conflict = 409;

  /// Gone
  static const int gone = 410;

  /// Length Required
  static const int lengthRequired = 411;

  /// Precondition Failed
  static const int preconditionFailed = 412;

  /// Request Entity Too Large
  static const int requestEntityTooLarge = 413;

  /// Request URI Too Long
  static const int requestUriTooLong = 414;

  /// Unsupported Media Type
  static const int unsupportedMediaType = 415;

  /// Requested Range Not Satisfiable
  static const int requestedRangeNotSatisfiable = 416;

  /// Expectation Failed
  static const int expectationFailed = 417;

  /// I'm a teapot
  static const int imATeapot = 418;

  /// Insufficient Space on Resource
  static const int insufficientSpaceOnResource = 419;

  /// Method Failure
  static const int methodFailure = 420;

  /// Misdirected Request
  static const int misdirectedRequest = 421;

  /// Unprocessable Entity
  static const int unprocessableEntity = 422;

  /// Locked
  static const int locked = 423;

  /// Failed Dependency
  static const int failedDependency = 424;

  /// Upgrade Required
  static const int upgradeRequired = 426;

  /// Precondition Required
  static const int preconditionRequired = 428;

  /// Too Many Requests
  static const int tooManyRequests = 429;

  /// Request Header Fields Too Large
  static const int requestHeaderFieldsTooLarge = 431;

  /// Connection Closed Without Response
  static const int connectionClosedWithoutResponse = 444;

  /// Unavailable For Legal Reasons
  static const int unavailableForLegalReasons = 451;

  /// Client Closed Request
  static const int clientClosedRequest = 499;

  // 5xx Server Error
  /// Internal Server Error
  static const int internalServerError = 500;

  /// Not Implemented
  static const int notImplemented = 501;

  /// Bad Gateway
  static const int badGateway = 502;

  /// Service Unavailable
  static const int serviceUnavailable = 503;

  /// Gateway Timeout
  static const int gatewayTimeout = 504;

  /// HTTP Version Not Supported
  static const int httpVersionNotSupported = 505;

  /// Variant Also Negotiates
  static const int variantAlsoNegotiates = 506;

  /// Insufficient Storage
  static const int insufficientStorage = 507;

  /// Loop Detected
  static const int loopDetected = 508;

  /// Not Extended
  static const int notExtended = 510;

  /// Network Authentication Required
  static const int networkAuthenticationRequired = 511;

  /// Network Connect Timeout Error
  static const int networkConnectTimeoutError = 599;
}

/// Base exception class for HTTP-related errors
class PHttpException implements Exception {
  /// HTTP status code
  final int statusCode;

  /// Error message
  final String message;

  /// Creates a new HTTP exception
  PHttpException(this.statusCode, this.message);

  @override
  String toString() {
    return 'PHttpException: $statusCode - $message';
  }

  /// Converts the exception to JSON
  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'message': message,
    };
  }
}

/// Exception for 400 Bad Request
class BadRequestException extends PHttpException {
  BadRequestException()
      : super(
          PHttpStatusCode.badRequest,
          'Bad Request',
        );
}

/// Exception for 401 Unauthorized
class UnauthorizedException extends PHttpException {
  UnauthorizedException()
      : super(
          PHttpStatusCode.unauthorized,
          'Unauthorized',
        );
}

/// Exception for 402 Payment Required
class PaymentRequiredException extends PHttpException {
  PaymentRequiredException()
      : super(
          PHttpStatusCode.paymentRequired,
          'Payment Required',
        );
}

/// Exception for 403 Forbidden
class ForbiddenException extends PHttpException {
  ForbiddenException()
      : super(
          PHttpStatusCode.forbidden,
          'Forbidden',
        );
}

/// Exception for 404 Not Found
class NotFoundException extends PHttpException {
  NotFoundException()
      : super(
          PHttpStatusCode.notFound,
          'Not Found',
        );
}

/// Exception for 405 Method Not Allowed
class MethodNotAllowedException extends PHttpException {
  MethodNotAllowedException()
      : super(
          PHttpStatusCode.methodNotAllowed,
          'Method Not Allowed',
        );
}

/// Exception for 406 Not Acceptable
class NotAcceptableException extends PHttpException {
  NotAcceptableException()
      : super(
          PHttpStatusCode.notAcceptable,
          'Not Acceptable',
        );
}

/// Exception for 407 Proxy Authentication Required
class ProxyAuthenticationRequiredException extends PHttpException {
  ProxyAuthenticationRequiredException()
      : super(
          PHttpStatusCode.proxyAuthenticationRequired,
          'Proxy Authentication Required',
        );
}

/// Exception for 408 Request Timeout
class RequestTimeoutException extends PHttpException {
  RequestTimeoutException()
      : super(
          PHttpStatusCode.requestTimeout,
          'Request Timeout',
        );
}

/// Exception for 409 Conflict
class ConflictException extends PHttpException {
  ConflictException()
      : super(
          PHttpStatusCode.conflict,
          'Conflict',
        );
}

/// Exception for 410 Gone
class GoneException extends PHttpException {
  GoneException()
      : super(
          PHttpStatusCode.gone,
          'Gone',
        );
}

/// Exception for 411 Length Required
class LengthRequiredException extends PHttpException {
  LengthRequiredException()
      : super(
          PHttpStatusCode.lengthRequired,
          'Length Required',
        );
}

class PreconditionFailedException extends PHttpException {
  PreconditionFailedException()
      : super(
          PHttpStatusCode.preconditionFailed,
          'Precondition Failed',
        );
}

class RequestEntityTooLargeException extends PHttpException {
  RequestEntityTooLargeException()
      : super(
          PHttpStatusCode.requestEntityTooLarge,
          'Request Entity Too Large',
        );
}

class RequestUriTooLongException extends PHttpException {
  RequestUriTooLongException()
      : super(
          PHttpStatusCode.requestUriTooLong,
          'Request URI Too Long',
        );
}

class UnsupportedMediaTypeException extends PHttpException {
  UnsupportedMediaTypeException()
      : super(
          PHttpStatusCode.unsupportedMediaType,
          'Unsupported Media Type',
        );
}

class RequestedRangeNotSatisfiableException extends PHttpException {
  RequestedRangeNotSatisfiableException()
      : super(
          PHttpStatusCode.requestedRangeNotSatisfiable,
          'Requested Range Not Satisfiable',
        );
}

class ExpectationFailedException extends PHttpException {
  ExpectationFailedException()
      : super(
          PHttpStatusCode.expectationFailed,
          'Expectation Failed',
        );
}

class ImATeapotException extends PHttpException {
  ImATeapotException()
      : super(
          PHttpStatusCode.imATeapot,
          'I\'m a teapot',
        );
}

class InsufficientSpaceOnResourceException extends PHttpException {
  InsufficientSpaceOnResourceException()
      : super(
          PHttpStatusCode.insufficientSpaceOnResource,
          'Insufficient Space On Resource',
        );
}

class MethodFailureException extends PHttpException {
  MethodFailureException()
      : super(
          PHttpStatusCode.methodFailure,
          'Method Failure',
        );
}

class MisdirectedRequestException extends PHttpException {
  MisdirectedRequestException()
      : super(
          PHttpStatusCode.misdirectedRequest,
          'Misdirected Request',
        );
}

class UnprocessableEntityException extends PHttpException {
  UnprocessableEntityException()
      : super(
          PHttpStatusCode.unprocessableEntity,
          'Unprocessable Entity',
        );
}

class LockedException extends PHttpException {
  LockedException()
      : super(
          PHttpStatusCode.locked,
          'Locked',
        );
}

class FailedDependencyException extends PHttpException {
  FailedDependencyException()
      : super(
          PHttpStatusCode.failedDependency,
          'Failed Dependency',
        );
}

class UpgradeRequiredException extends PHttpException {
  UpgradeRequiredException()
      : super(
          PHttpStatusCode.upgradeRequired,
          'Upgrade Required',
        );
}

class PreconditionRequiredException extends PHttpException {
  PreconditionRequiredException()
      : super(
          PHttpStatusCode.preconditionRequired,
          'Precondition Required',
        );
}

class TooManyRequestsException extends PHttpException {
  TooManyRequestsException()
      : super(
          PHttpStatusCode.tooManyRequests,
          'Too Many Requests',
        );
}

class RequestHeaderFieldsTooLargeException extends PHttpException {
  RequestHeaderFieldsTooLargeException()
      : super(
          PHttpStatusCode.requestHeaderFieldsTooLarge,
          'Request Header Fields Too Large',
        );
}

class ConnectionClosedWithoutResponseException extends PHttpException {
  ConnectionClosedWithoutResponseException()
      : super(
          PHttpStatusCode.connectionClosedWithoutResponse,
          'Connection Closed Without Response',
        );
}

class UnavailableForLegalReasonsException extends PHttpException {
  UnavailableForLegalReasonsException()
      : super(
          PHttpStatusCode.unavailableForLegalReasons,
          'Unavailable For Legal Reasons',
        );
}

class ClientClosedRequestException extends PHttpException {
  ClientClosedRequestException()
      : super(
          PHttpStatusCode.clientClosedRequest,
          'Client Closed Request',
        );
}

class InternalServerErrorException extends PHttpException {
  InternalServerErrorException()
      : super(
          PHttpStatusCode.internalServerError,
          'Internal Server Error',
        );
}

class NotImplementedException extends PHttpException {
  NotImplementedException()
      : super(
          PHttpStatusCode.notImplemented,
          'Not Implemented',
        );
}

class BadGatewayException extends PHttpException {
  BadGatewayException()
      : super(
          PHttpStatusCode.badGateway,
          'Bad Gateway',
        );
}

class ServiceUnavailableException extends PHttpException {
  ServiceUnavailableException()
      : super(
          PHttpStatusCode.serviceUnavailable,
          'Service Unavailable',
        );
}

class GatewayTimeoutException extends PHttpException {
  GatewayTimeoutException()
      : super(
          PHttpStatusCode.gatewayTimeout,
          'Gateway Timeout',
        );
}

class HttpVersionNotSupportedException extends PHttpException {
  HttpVersionNotSupportedException()
      : super(
          PHttpStatusCode.httpVersionNotSupported,
          'HTTP Version Not Supported',
        );
}

class VariantAlsoNegotiatesException extends PHttpException {
  VariantAlsoNegotiatesException()
      : super(
          PHttpStatusCode.variantAlsoNegotiates,
          'Variant Also Negotiates',
        );
}

class InsufficientStorageException extends PHttpException {
  InsufficientStorageException()
      : super(
          PHttpStatusCode.insufficientStorage,
          'Insufficient Storage',
        );
}

class LoopDetectedException extends PHttpException {
  LoopDetectedException()
      : super(
          PHttpStatusCode.loopDetected,
          'Loop Detected',
        );
}

class NotExtendedException extends PHttpException {
  NotExtendedException()
      : super(
          PHttpStatusCode.notExtended,
          'Not Extended',
        );
}

class NetworkAuthenticationRequiredException extends PHttpException {
  NetworkAuthenticationRequiredException()
      : super(
          PHttpStatusCode.networkAuthenticationRequired,
          'Network Authentication Required',
        );
}

class NetworkConnectTimeoutErrorException extends PHttpException {
  NetworkConnectTimeoutErrorException()
      : super(
          PHttpStatusCode.networkConnectTimeoutError,
          'Network Connect Timeout Error',
        );
}
