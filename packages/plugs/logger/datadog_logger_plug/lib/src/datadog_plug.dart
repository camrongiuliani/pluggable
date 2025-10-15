import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:pluggable/pluggable.dart';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:shelf/shelf.dart' as shelf;
import 'package:dart_frog/dart_frog.dart' as frog;
import 'package:uuid/uuid.dart';
import 'package:universal_io/io.dart';

import 'mappers/exports.dart';
import 'util/log_batcher.dart';
import 'models/models.dart';

class DataDogAnalyticsPlug extends PluggableLogger
    with _DioMixin, _ShelfMixin, _DartFrogMixin {
  final ConsoleLoggerPlug _consoleLogger;
  final String _source;
  final String _service;
  final String _hostname;
  final String _apiKey;
  final String _loggingUrl;
  final LogBatcher _logBatcher;
  final LogLevel _consoleLogLevel;
  final LogLevel _remoteLogLevel;

  DataDogAnalyticsPlug({
    required String apiKey,
    required String loggingUrl,
    required String source,
    required String service,
    required String hostname,
    Duration? batchInterval,
    int? batchSize,
    int connectTimeoutMs = 60000,
    int receiveTimeoutMs = 60000,
    LogLevel consoleLogLevel = LogLevel.debug,
    LogLevel remoteLogLevel = LogLevel.info,
  }) : _consoleLogger = ConsoleLoggerPlug(),
       _apiKey = apiKey,
       _hostname = hostname,
       _service = service,
       _loggingUrl = loggingUrl,
       _source = source,
       _consoleLogLevel = consoleLogLevel,
       _remoteLogLevel = remoteLogLevel,
       _logBatcher = LogBatcher(
         apiKey: apiKey,
         loggingUrl: loggingUrl,
         batchInterval: batchInterval,
         batchSize: batchSize,
         connectTimeoutMs: connectTimeoutMs,
         receiveTimeoutMs: receiveTimeoutMs,
       );

  DDLogRequest get baseRequest {
    return DDLogRequest(
      apiKey: _apiKey,
      loggingUrl: _loggingUrl,
      timestamp: DateTime.now().toUtc().toIso8601String(),
      requestId: '',
      traceId: const Uuid().v4(),
      source: _source,
      hostname: _hostname,
      message: '',
      service: _service,
      tags: ['env_name:$_hostname', 'zone:$_service'].join(','),
      statusCategory: StatusCategory.info,
    );
  }

  @override
  Future<PluggableLogger> init() async {
    Pluggable.mapper.buildAtlas([...DioRequestMapper.all(Pluggable.mapper)]);

    return this;
  }

  @override
  Future<Plug> dispose() async {
    _logBatcher.dispose();
    return this;
  }

  http.Client httpClient({String? traceId, http.Client? client}) {
    return LoggingClient(client: client ?? http.Client(), traceId: traceId);
  }

  @override
  void d(
    String message, {
    String? tag,
    Object? err,
    String? traceId,
    StackTrace? stackTrace,
  }) {
    if (_consoleLogLevel.index >= LogLevel.debug.index) {
      _consoleLogger.d(
        message,
        tag: tag,
        traceId: traceId,
        err: err,
        stackTrace: stackTrace,
      );
    }

    if (_remoteLogLevel.index >= LogLevel.debug.index) {
      _log(
        baseRequest.copyWith(
          requestId: traceId ?? tag ?? '',
          traceId: traceId ?? const Uuid().v4(),
          message: [
            '[LOG]',
            '[DEBUG]',
            if (tag != null) '[$tag]',
            if (traceId != null) '[$traceId]',
            message,
          ].join(' '),
          statusCategory: StatusCategory.info,
        ),
      );
    }
  }

  @override
  void e(
    String message, {
    String? tag,
    String? traceId,
    Object? err,
    StackTrace? stackTrace,
  }) {
    if (_consoleLogLevel.index >= LogLevel.error.index) {
      _consoleLogger.e(
        message,
        tag: tag,
        traceId: traceId,
        err: err,
        stackTrace: stackTrace,
      );
    }

    if (_remoteLogLevel.index >= LogLevel.error.index) {
      _log(
        baseRequest.copyWith(
          requestId: traceId ?? tag ?? '',
          traceId: traceId ?? const Uuid().v4(),
          message: [
            '[LOG]',
            '[ERROR]',
            if (tag != null) '[$tag]',
            if (traceId != null) '[$traceId]',
            message,
          ].join(' '),
          statusCategory: StatusCategory.error,
          errors: [
            if (err != null) err.toString(),
            if (stackTrace != null) stackTrace.toString(),
          ],
        ),
      );
    }
  }

  @override
  void header(
    String message, {
    String? tag,
    Object? err,
    StackTrace? stackTrace,
  }) {
    _consoleLogger.header(message, tag: tag, err: err, stackTrace: stackTrace);
  }

  @override
  void i(
    String message, {
    String? tag,
    String? traceId,
    Object? err,
    StackTrace? stackTrace,
  }) {
    if (_consoleLogLevel.index >= LogLevel.info.index) {
      _consoleLogger.i(
        message,
        tag: tag,
        traceId: traceId,
        err: err,
        stackTrace: stackTrace,
      );
    }

    if (_remoteLogLevel.index >= LogLevel.info.index) {
      _log(
        baseRequest.copyWith(
          requestId: traceId ?? tag ?? '',
          traceId: traceId ?? const Uuid().v4(),
          message: [
            '[LOG]',
            '[INFO]',
            if (tag != null) '[$tag]',
            if (traceId != null) '[$traceId]',
            message,
          ].join(' '),
          statusCategory: StatusCategory.info,
        ),
      );
    }
  }

  @override
  void v(
    String message, {
    bool showPrefix = true,
    String? tag,
    String? traceId,
    Object? err,
    StackTrace? stackTrace,
  }) {
    if (_consoleLogLevel.index >= LogLevel.verbose.index) {
      _consoleLogger.v(
        message,
        tag: tag,
        traceId: traceId,
        err: err,
        stackTrace: stackTrace,
      );
    }

    if (_remoteLogLevel.index >= LogLevel.verbose.index) {
      _log(
        baseRequest.copyWith(
          requestId: traceId ?? tag ?? '',
          traceId: traceId ?? const Uuid().v4(),
          message: [
            '[LOG]',
            '[VERBOSE]',
            if (tag != null) '[$tag]',
            if (traceId != null) '[$traceId]',
            message,
          ].join(' '),
          statusCategory: StatusCategory.info,
        ),
      );
    }
  }

  void _log(DDLogRequest payload) {
    _logBatcher.addLog(payload);
  }

  void apiRequest({
    required PHttpRequest request,
    required LogType type,
    PHttpResponse? response,
  }) {
    _log(
      DDApiLogRequest(
        apiKey: _apiKey,
        loggingUrl: _loggingUrl,
        timestamp:
            request.headers['x-exec-time']?.toString() ??
            DateTime.now().toUtc().toIso8601String(),
        requestId: request.requestId,
        traceId: request.requestId,
        source: _source,
        hostname: _hostname,
        message: [
          switch (type) {
            LogType.outboundRequest => '[OUTBOUND]',
            LogType.inboundRequest => '[INBOUND]',
          },
          '[${request.method.value}]',
          '[${response?.message ?? 'OK'}]',
          '[${request.requestId}]',
          '[${request.uri.path}]',
        ].join(' '),
        service: _service,
        tags: ['env_name:$_hostname', 'zone:$_service'].join(','),
        statusCategory: StatusCategory.fromHttpStatusCode(response?.statusCode),
        type: type,
        http: HttpDetails(
          url: request.uri.toString(),
          statusCode: response?.statusCode,
          statusMessage: response?.message,
          method: request.method,
          statusCategory: StatusCategory.fromHttpStatusCode(
            response?.statusCode,
          ),
          urlDetails: UrlDetails(
            path: request.path,
            host: request.host,
            query: request.queryParameters,
          ),
          request: RequestDetails(
            headers: request.headers,
            body: switch (request) {
              PHttpJsonDataRequest r => r.data,
              PHttpFormDataRequest r => r.data.fields,
              _ => null,
            },
          ),
          response: switch (response) {
            null => null,
            _ => ResponseDetails(
              headers: response.headers,
              statusMessage: response.message,
              statusCode: response.statusCode,
              body: response.data,
            ),
          },
        ),
      ),
    );
  }
}

mixin _ShelfMixin {
  DataDogAnalyticsPlug get logger => Pluggable.logger as DataDogAnalyticsPlug;

  shelf.Middleware get shelfMiddleware => (innerHandler) {
    final execStartTime = DateTime.now().toUtc();

    return (request) async {
      try {
        final reqBytes = <int>[];
        final resBytes = <int>[];

        PHttpRequest? pReq;
        PHttpResponse? pResp;

        final reqId = request.headers['x-request-id'] ?? const Uuid().v4();

        return Future.value(
          innerHandler(
            request.change(
              headers: Map.from(request.headers)
                ..putIfAbsent('x-request-id', () => reqId),
              body: request.read().transform<List<int>>(
                StreamTransformer<Uint8List, List<int>>.fromHandlers(
                  handleData: (data, sink) {
                    sink.add(data);
                    reqBytes.addAll(data);
                  },
                  handleDone: (sink) {
                    sink.close();

                    final contentType = request.headers['content-type'] ?? '';
                    final requestData = switch (contentType) {
                      'application/json' => jsonDecode(utf8.decode(reqBytes)),
                      'text' || 'text/plain' => utf8.decode(reqBytes),
                      // 'application/x-www-form-urlencoded' => await copy.formData(),
                      _ => '<non-textual content>',
                    };

                    pReq = PHttpRequest.withData(
                      uri: request.requestedUri,
                      requestId: reqId,
                      method: PHttpMethod.parse(request.method.toUpperCase()),
                      headers: request.headers.map(
                        (key, value) => MapEntry(key, value.toString()),
                      ),
                      queryParameters: request.requestedUri.queryParameters,
                      // persistentConnection: request.persistentConnection,
                      clientIP:
                          request.context['shelf.io.connection_info'] != null
                              ? (request.context['shelf.io.connection_info']
                                      as HttpConnectionInfo)
                                  .remoteAddress
                                  .address
                              : '',
                      followRedirects: true,
                      maxRedirects: 5,
                      data: requestData,
                    );
                  },
                ),
              ),
            ),
          ),
        ).then((response) {
          return response.change(
            body: response.read().cast<List<int>>().transform<List<int>>(
              StreamTransformer<List<int>, List<int>>.fromHandlers(
                handleData: (data, sink) {
                  sink.add(data);
                  resBytes.addAll(data);
                },
                handleDone: (sink) {
                  sink.close();

                  final contentType = response.headers['content-type'] ?? '';
                  final responseData = switch (contentType) {
                    'application/json' => jsonDecode(utf8.decode(resBytes)),
                    'text' || 'text/plain' => utf8.decode(resBytes),
                    // 'application/x-www-form-urlencoded' => await copy.formData(),
                    _ => '<non-textual content>',
                  };
                  pResp = PHttpResponse(
                    headers: response.headers,
                    statusCode: response.statusCode,
                    data: responseData,
                    message: switch (response.statusCode) {
                      >= 200 && < 300 => 'OK',
                      >= 400 && < 500 => 'Client Error',
                      >= 500 => 'Server Error',
                      _ => 'General Error',
                    },
                  );

                  logger.apiRequest(
                    request: pReq!.copyWith(
                      headers: {
                        ...pReq!.headers,
                        'x-exec-time': execStartTime.toIso8601String(),
                      },
                    ),
                    response: pResp!,
                    type: LogType.inboundRequest,
                  );
                },
              ),
            ),
          );
        });
      } catch (e) {
        // ignore: avoid_print
        print('Error in datadog logging plug shelf middleware: $e');
        return innerHandler(request);
      }
    };
  };
}

mixin _DartFrogMixin {
  DataDogAnalyticsPlug get logger => Pluggable.logger as DataDogAnalyticsPlug;

  frog.Middleware get dartFrogMiddleware =>
      frog.fromShelfMiddleware(logger.shelfMiddleware);
}

mixin _DioMixin implements InterceptorsWrapper {
  DataDogAnalyticsPlug get logger => Pluggable.logger as DataDogAnalyticsPlug;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      Future.wait([
        Pluggable.mapper.mapAsync<RequestOptions, PHttpRequest>(
          err.requestOptions,
        ),
        Pluggable.mapper.mapAsync<Response, PHttpResponse>(
          err.response ??
              Response(
                requestOptions: err.requestOptions,
                statusCode: 0,
                statusMessage: err.message ?? err.stackTrace.toString(),
              ),
        ),
      ]).then((results) {
        final request = results[0] as PHttpRequest;
        final resp = results[1] as PHttpResponse;

        logger.apiRequest(
          request: request,
          response: resp,
          type: LogType.outboundRequest,
        );
      });
    } catch (e) {
      print('Error logging outbound request error: $e');
    }

    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers.putIfAbsent('x-request-id', () => const Uuid().v4());
    options.headers.putIfAbsent(
      'x-exec-time',
      () => DateTime.now().toUtc().toIso8601String(),
    );

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      Future.wait([
        Pluggable.mapper.mapAsync<RequestOptions, PHttpRequest>(
          response.requestOptions,
        ),
        Pluggable.mapper.mapAsync<Response, PHttpResponse>(response),
      ]).then((results) {
        final request = results[0] as PHttpRequest;
        final resp = results[1] as PHttpResponse;

        logger.apiRequest(
          request: request,
          response: resp,
          type: LogType.outboundRequest,
        );
      });
    } catch (e) {
      print('Error logging outbound request: $e');
    }

    handler.next(response);
  }
}

class LoggingClient extends http.BaseClient {
  DataDogAnalyticsPlug get logger => Pluggable.logger as DataDogAnalyticsPlug;

  final http.Client _inner;

  LoggingClient({required http.Client client, this.traceId}) : _inner = client;

  final String? traceId;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final reqId =
        traceId ?? request.headers['x-request-id'] ?? const Uuid().v4();
    request.headers.putIfAbsent('x-request-id', () => reqId);

    final dataRequest = PHttpRequest.withData(
      uri: request.url,
      requestId: reqId,
      method: PHttpMethod.parse(request.method.toUpperCase()),
      headers: request.headers.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
      queryParameters: request.url.queryParameters,
      persistentConnection: request.persistentConnection,
      clientIP: '',
      followRedirects: request.followRedirects,
      maxRedirects: request.maxRedirects,
      data: switch (request) {
        http.Request r => r.bodyBytes,
        http.MultipartRequest r => PFormData(
          fields: r.fields,
          files: {
            for (final file in r.files)
              file.field: PFormFile(
                file.field,
                ContentType.parse(file.contentType.mimeType),
                file.finalize(),
              ),
          },
        ),
        http.StreamedRequest _ => null,
        _ => null,
      },
    );

    PHttpResponse? httpResponse;

    // try {
    //   return json.decode(utf8.decode(response.bodyBytes));
    // } catch (error) {
    //   throw _handleError(error);
    // }

    final method = PHttpMethod.parse(request.method.toUpperCase());

    final response = await switch (method) {
          PHttpMethod.head => _inner.head(
            request.url,
            headers: request.headers,
          ),
          PHttpMethod.options => _inner.head(
            request.url,
            headers: request.headers,
          ),
          PHttpMethod.get => _inner.get(request.url, headers: request.headers),
          PHttpMethod.post => _inner.post(
            request.url,
            headers: request.headers,
            body: switch (request) {
              http.Request r => r.body,
              http.MultipartRequest r => switch (r.fields.isEmpty) {
                true => null,
                false => r.fields,
              },
              http.StreamedRequest r => r.sink,
              http.BaseRequest() => null,
            },
          ),
          PHttpMethod.put => _inner.put(
            request.url,
            headers: request.headers,
            body: switch (request) {
              http.Request r => r.body,
              http.MultipartRequest r => switch (r.fields.isEmpty) {
                true => null,
                false => r.fields,
              },
              http.StreamedRequest r => r.sink,
              http.BaseRequest() => null,
            },
          ),
          PHttpMethod.delete => _inner.delete(
            request.url,
            headers: request.headers,
            body: switch (request) {
              http.Request r => r.body,
              http.MultipartRequest r => switch (r.fields.isEmpty) {
                true => null,
                false => r.fields,
              },
              http.StreamedRequest r => r.sink,
              http.BaseRequest() => null,
            },
          ),
          PHttpMethod.patch => _inner.patch(
            request.url,
            headers: request.headers,
            body: switch (request) {
              http.Request r => r.body,
              http.MultipartRequest r => switch (r.fields.isEmpty) {
                true => null,
                false => r.fields,
              },
              http.StreamedRequest r => r.sink,
              http.BaseRequest() => null,
            },
          ),
        }
        .onError((error, stackTrace) {
          logger.apiRequest(
            type: LogType.outboundRequest,
            request: dataRequest,
            response: PHttpResponse(
              statusCode: 0,
              message: error.toString(),
              headers: {},
              data: null,
            ),
          );

          if (error is Exception) {
            throw error;
          } else {
            throw Exception(error.toString());
          }
        })
        .then((res) {
          httpResponse = PHttpResponse(
            statusCode: res.statusCode,
            message: res.reasonPhrase ?? '',
            headers: res.headers,
            data: res.body,
          );

          logger.apiRequest(
            request: dataRequest,
            response: httpResponse,
            type: LogType.outboundRequest,
          );

          return res;
        });

    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      contentLength: response.contentLength,
      request: request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }
}
