import 'dart:io';

/// A raw, fully-custom HTTP response that bypasses the default wrapping
/// performed by [PRequestHandler].
///
/// By default, [PRequestHandler] wraps primitive responses in
/// `{ "requestId": ..., "data": ... }` and auto-detects the `Content-Type`
/// header. Return a [PRawResponse] from a handler method when you need full
/// control over the response — for example to:
///
/// - Return a raw byte payload (e.g. a file download or image).
/// - Return a JSON body that does **not** include `requestId` / `data`.
/// - Return plain text, XML, or any other content type with a custom body.
/// - Use a non-200 status code with a custom body shape.
///
/// The handler will still merge the `x-request-id` header and any headers
/// previously registered via [PRequestHandler.addResponseHeader] unless the
/// raw response sets the same key, in which case the raw response wins.
///
/// Example:
/// ```dart
/// @override
/// FutureOr<Object?> get() async {
///   final bytes = await loadFileBytes();
///   return PRawResponse.bytes(
///     body: bytes,
///     contentType: ContentType('image', 'png'),
///   );
/// }
/// ```
class PRawResponse {
  /// The raw response body. Supported runtime types are:
  ///
  /// - [String] — written as-is.
  /// - [List<int>] — written as a byte payload.
  /// - [Stream<List<int>>] — streamed to the client.
  /// - [Map] / [List] — encoded by the server plug (typically JSON).
  /// - `null` — empty body.
  final Object? body;

  /// HTTP status code to return. Defaults to `200`.
  final int statusCode;

  /// Optional `Content-Type` to set on the response. When provided, this
  /// value overrides any auto-detected content type.
  final ContentType? contentType;

  /// Additional headers to include on the response. These are merged on top
  /// of any headers registered on the handler via
  /// [PRequestHandler.addResponseHeader].
  final Map<String, Object> headers;

  /// Whether to include the `x-request-id` header automatically. Defaults
  /// to `true`. Set to `false` if you need a fully clean response with no
  /// pluggable-specific headers.
  final bool includeRequestId;

  /// Creates a fully custom response.
  const PRawResponse({
    this.body,
    this.statusCode = 200,
    this.contentType,
    this.headers = const {},
    this.includeRequestId = true,
  });

  /// Creates a raw byte response. Sets `Content-Type` to
  /// `application/octet-stream` unless [contentType] is provided.
  factory PRawResponse.bytes({
    required List<int> body,
    int statusCode = 200,
    ContentType? contentType,
    Map<String, Object> headers = const {},
    bool includeRequestId = true,
  }) {
    return PRawResponse(
      body: body,
      statusCode: statusCode,
      contentType: contentType ?? ContentType.binary,
      headers: headers,
      includeRequestId: includeRequestId,
    );
  }

  /// Creates a streamed response. Sets `Content-Type` to
  /// `application/octet-stream` unless [contentType] is provided.
  factory PRawResponse.stream({
    required Stream<List<int>> body,
    int statusCode = 200,
    ContentType? contentType,
    Map<String, Object> headers = const {},
    bool includeRequestId = true,
  }) {
    return PRawResponse(
      body: body,
      statusCode: statusCode,
      contentType: contentType ?? ContentType.binary,
      headers: headers,
      includeRequestId: includeRequestId,
    );
  }

  /// Creates a plain-text response. Sets `Content-Type` to `text/plain`
  /// unless [contentType] is provided.
  factory PRawResponse.text({
    required String body,
    int statusCode = 200,
    ContentType? contentType,
    Map<String, Object> headers = const {},
    bool includeRequestId = true,
  }) {
    return PRawResponse(
      body: body,
      statusCode: statusCode,
      contentType: contentType ?? ContentType.text,
      headers: headers,
      includeRequestId: includeRequestId,
    );
  }

  /// Creates a JSON response with a fully custom body shape (no `requestId`
  /// / `data` wrapping). Sets `Content-Type` to `application/json` unless
  /// [contentType] is provided.
  factory PRawResponse.json({
    required Object body,
    int statusCode = 200,
    ContentType? contentType,
    Map<String, Object> headers = const {},
    bool includeRequestId = true,
  }) {
    return PRawResponse(
      body: body,
      statusCode: statusCode,
      contentType: contentType ?? ContentType.json,
      headers: headers,
      includeRequestId: includeRequestId,
    );
  }
}
