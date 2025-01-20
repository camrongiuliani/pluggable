abstract class PHttpStatusCode {
  static const int continue_ = 100;

  static const int switchingProtocols = 101;

  static const int processing = 102;

  static const int earlyHints = 103;

  static const int ok = 200;

  static const int created = 201;

  static const int accepted = 202;

  static const int nonAuthoritativeInformation = 203;

  static const int noContent = 204;

  static const int resetContent = 205;

  static const int partialContent = 206;

  static const int multiStatus = 207;

  static const int alreadyReported = 208;

  static const int imUsed = 226;

  static const int multipleChoices = 300;

  static const int movedPermanently = 301;

  static const int found = 302;

  static const int movedTemporarily = 302;

  static const int seeOther = 303;

  static const int notModified = 304;

  static const int useProxy = 305;

  static const int temporaryRedirect = 307;

  static const int permanentRedirect = 308;

  static const int badRequest = 400;

  static const int unauthorized = 401;

  static const int paymentRequired = 402;

  static const int forbidden = 403;

  static const int notFound = 404;

  static const int methodNotAllowed = 405;

  static const int notAcceptable = 406;

  static const int proxyAuthenticationRequired = 407;

  static const int requestTimeout = 408;

  static const int conflict = 409;

  static const int gone = 410;

  static const int lengthRequired = 411;

  static const int preconditionFailed = 412;

  static const int requestEntityTooLarge = 413;

  static const int requestUriTooLong = 414;

  static const int unsupportedMediaType = 415;

  static const int requestedRangeNotSatisfiable = 416;

  static const int expectationFailed = 417;

  static const int imATeapot = 418;

  static const int insufficientSpaceOnResource = 419;

  static const int methodFailure = 420;

  static const int misdirectedRequest = 421;

  static const int unprocessableEntity = 422;

  static const int locked = 423;

  static const int failedDependency = 424;

  static const int upgradeRequired = 426;

  static const int preconditionRequired = 428;

  static const int tooManyRequests = 429;

  static const int requestHeaderFieldsTooLarge = 431;

  static const int connectionClosedWithoutResponse = 444;

  static const int unavailableForLegalReasons = 451;

  static const int clientClosedRequest = 499;

  static const int internalServerError = 500;

  static const int notImplemented = 501;

  static const int badGateway = 502;

  static const int serviceUnavailable = 503;

  static const int gatewayTimeout = 504;

  static const int httpVersionNotSupported = 505;

  static const int variantAlsoNegotiates = 506;

  static const int insufficientStorage = 507;

  static const int loopDetected = 508;

  static const int notExtended = 510;

  static const int networkAuthenticationRequired = 511;

  static const int networkConnectTimeoutError = 599;
}

class PHttpException implements Exception {
  final int statusCode;
  final String message;

  PHttpException(this.statusCode, this.message);

  @override
  String toString() {
    return 'PHttpException: $statusCode - $message';
  }
}

class BadRequestException extends PHttpException {
  BadRequestException()
      : super(
          PHttpStatusCode.badRequest,
          'Bad Request',
        );
}

class UnauthorizedException extends PHttpException {
  UnauthorizedException()
      : super(
          PHttpStatusCode.unauthorized,
          'Unauthorized',
        );
}

class PaymentRequiredException extends PHttpException {
  PaymentRequiredException()
      : super(
          PHttpStatusCode.paymentRequired,
          'Payment Required',
        );
}

class ForbiddenException extends PHttpException {
  ForbiddenException()
      : super(
          PHttpStatusCode.forbidden,
          'Forbidden',
        );
}

class NotFoundException extends PHttpException {
  NotFoundException()
      : super(
          PHttpStatusCode.notFound,
          'Not Found',
        );
}

class MethodNotAllowedException extends PHttpException {
  MethodNotAllowedException()
      : super(
          PHttpStatusCode.methodNotAllowed,
          'Method Not Allowed',
        );
}

class NotAcceptableException extends PHttpException {
  NotAcceptableException()
      : super(
          PHttpStatusCode.notAcceptable,
          'Not Acceptable',
        );
}

class ProxyAuthenticationRequiredException extends PHttpException {
  ProxyAuthenticationRequiredException()
      : super(
          PHttpStatusCode.proxyAuthenticationRequired,
          'Proxy Authentication Required',
        );
}

class RequestTimeoutException extends PHttpException {
  RequestTimeoutException()
      : super(
          PHttpStatusCode.requestTimeout,
          'Request Timeout',
        );
}

class ConflictException extends PHttpException {
  ConflictException()
      : super(
          PHttpStatusCode.conflict,
          'Conflict',
        );
}

class GoneException extends PHttpException {
  GoneException()
      : super(
          PHttpStatusCode.gone,
          'Gone',
        );
}

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
