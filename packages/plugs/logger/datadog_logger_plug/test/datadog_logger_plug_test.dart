import 'dart:convert';

import 'package:datadog_logger_plug/src/models/http_details.dart';
import 'package:datadog_logger_plug/src/models/log_request.dart';
import 'package:datadog_logger_plug/src/models/enums/enums.dart';
import 'package:datadog_logger_plug/src/models/request_details.dart';
import 'package:datadog_logger_plug/src/models/response_details.dart';
import 'package:datadog_logger_plug/src/models/url_details.dart';
import 'package:datadog_logger_plug/src/util/log_batcher.dart';
import 'package:datadog_logger_plug/src/util/sanitizer.dart';
import 'package:pluggable/pluggable.dart';
import 'package:test/test.dart';

const _maskedKeys = ['password', 'authorization'];

DDApiLogRequest _buildApiLog({
  Map<String, dynamic>? requestHeaders,
  dynamic requestBody,
  Map<String, dynamic>? responseHeaders,
  dynamic responseBody,
  String message = '[OUTBOUND] [POST] [OK] [req-1] [/auth]',
}) {
  return DDApiLogRequest(
    apiKey: 'fake',
    loggingUrl: 'https://example.com',
    timestamp: '2026-05-15T00:00:00.000Z',
    requestId: 'req-1',
    traceId: 'trace-1',
    source: 'test',
    tags: '',
    hostname: 'test-host',
    message: message,
    service: 'test-service',
    statusCategory: StatusCategory.info,
    type: LogType.outboundRequest,
    http: HttpDetails(
      url: 'https://example.com/auth',
      method: PHttpMethod.post,
      statusCategory: StatusCategory.info,
      urlDetails: UrlDetails(path: '/auth', host: 'example.com', query: const {}),
      request: RequestDetails(
        headers: requestHeaders ?? const {},
        body: requestBody,
      ),
      response: responseHeaders == null && responseBody == null
          ? null
          : ResponseDetails(
              headers: responseHeaders ?? const {},
              statusCode: 200,
              statusMessage: 'OK',
              body: responseBody,
            ),
    ),
  );
}

void main() {
  group('Sanitizer.obfuscateMap', () {
    test('masks Authorization header regardless of key casing', () {
      final headers = {
        'Authorization': 'Basic dXNlcjpwYXNzd29yZA==',
        'Content-Type': 'application/x-www-form-urlencoded',
      };

      final sanitized = Sanitizer.obfuscateMap(headers, maskedKeys: _maskedKeys);

      expect(sanitized['Authorization'], isNot(contains('dXNlcjpwYXNz')));
      expect(sanitized['Authorization'], equals('X' * 'Basic dXNlcjpwYXNzd29yZA=='.length));
      expect(sanitized['Content-Type'], equals('application/x-www-form-urlencoded'));
    });
  });

  group('sanitizeLogRequest', () {
    test('masks Basic auth Authorization header on the request', () {
      final log = _buildApiLog(
        requestHeaders: {
          'Authorization': 'Basic dXNlcjpwYXNzd29yZA==',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      );

      final sanitized = sanitizeLogRequest(log) as DDApiLogRequest;
      final headers = sanitized.http.request.headers;

      expect(headers['Authorization'], isNot(contains('dXNlcjpwYXNz')));
      expect(headers['Content-Type'], equals('application/x-www-form-urlencoded'));
    });

    test('masks password field in a structured request body', () {
      final log = _buildApiLog(
        requestBody: {'username': 'u', 'password': 'super-secret'},
      );

      final sanitized = sanitizeLogRequest(log) as DDApiLogRequest;
      final body = sanitized.http.request.body as Map<String, dynamic>;

      expect(body['password'], isNot(equals('super-secret')));
      expect(body['password'], equals('X' * 'super-secret'.length));
      expect(body['username'], isNotNull);
    });

    test('masks response headers and response body', () {
      final log = _buildApiLog(
        responseHeaders: {'Authorization': 'Bearer leaked-token'},
        responseBody: {'access_token': 'tok-123', 'user': 'u'},
      );

      final sanitized = sanitizeLogRequest(log) as DDApiLogRequest;
      final response = sanitized.http.response!;

      expect(response.headers['Authorization'], isNot(contains('leaked-token')));
      final body = response.body as Map<String, dynamic>;
      expect(body['access_token'], isNot(equals('tok-123')));
    });

    test('plain DDLogRequest only mutates message', () {
      final log = DDLogRequest(
        apiKey: 'fake',
        loggingUrl: 'https://example.com',
        timestamp: '2026-05-15T00:00:00.000Z',
        requestId: 'req-1',
        traceId: 'trace-1',
        source: 'test',
        tags: '',
        hostname: 'test-host',
        message: '[INFO] payload {"password": "secret-thing"}',
        service: 'test-service',
        statusCategory: StatusCategory.info,
      );

      final sanitized = sanitizeLogRequest(log);

      expect(sanitized.message, isNot(contains('secret-thing')));
      expect(sanitized, isNot(isA<DDApiLogRequest>()));
    });

    test('no plaintext password remains in JSON-encoded payload', () {
      final log = _buildApiLog(
        requestHeaders: {
          // base64('user:super-secret') = "dXNlcjpzdXBlci1zZWNyZXQ="
          'Authorization': 'Basic dXNlcjpzdXBlci1zZWNyZXQ=',
        },
        requestBody: {'username': 'user', 'password': 'super-secret'},
        responseBody: {'message': 'ok'},
      );

      final sanitized = sanitizeLogRequest(log);
      final encoded = jsonEncode(sanitized.toJson());

      expect(encoded, isNot(contains('super-secret')));
      expect(encoded, isNot(contains('dXNlcjpzdXBlci1zZWNyZXQ=')));
    });
  });
}
