// import 'package:savana_datadog/models/models.dart';
//
import 'enums/enums.dart';
import 'http_details.dart';

class DDLogRequest {
  final String apiKey;
  final String loggingUrl;
  final String timestamp;
  final String requestId;
  final String traceId;
  final StatusCategory statusCategory;
  final String source;
  final String tags;
  final String hostname;
  final String message;
  final String service;
  final Map<String, dynamic>? environment;
  final List<String>? errors;
  final Duration connectTimeout;
  final Duration receiveTimeout;

  DDLogRequest({
    required this.apiKey,
    required this.loggingUrl,
    required this.timestamp,
    required this.requestId,
    required this.traceId,
    required this.source,
    required this.tags,
    required this.hostname,
    required this.message,
    required this.service,
    required this.statusCategory,
    this.environment,
    this.errors,
    int connectTimeoutMs = 60000,
    int receiveTimeoutMs = 60000,
  }) : connectTimeout = Duration(milliseconds: connectTimeoutMs),
       receiveTimeout = Duration(milliseconds: receiveTimeoutMs);

  Map<String, dynamic> toJson() {
    return {
      'DD-API-KEY': apiKey,
      'loggingUrl': loggingUrl,
      'timestamp': timestamp,
      'requestId': requestId,
      'dd.trace_id': traceId,
      'ddsource': source,
      'ddtags': tags,
      'hostname': hostname,
      'message': message,
      'service': service,
      'status': statusCategory.name,
      if (environment != null) 'env': environment!,
      if (errors != null) 'errors': errors!,
    };
  }

  // copyWith
  DDLogRequest copyWith({
    String? apiKey,
    String? loggingUrl,
    String? timestamp,
    String? requestId,
    String? traceId,
    StatusCategory? statusCategory,
    String? source,
    String? tags,
    String? hostname,
    String? message,
    String? service,
    Map<String, dynamic>? environment,
    List<String>? errors,
  }) {
    return DDLogRequest(
      apiKey: apiKey ?? this.apiKey,
      loggingUrl: loggingUrl ?? this.loggingUrl,
      timestamp: timestamp ?? this.timestamp,
      requestId: requestId ?? this.requestId,
      traceId: traceId ?? this.traceId,
      statusCategory: statusCategory ?? this.statusCategory,
      source: source ?? this.source,
      tags: tags ?? this.tags,
      hostname: hostname ?? this.hostname,
      message: message ?? this.message,
      service: service ?? this.service,
      environment: environment ?? this.environment,
      errors: errors ?? this.errors,
    );
  }
}

class DDApiLogRequest extends DDLogRequest {
  final LogType type;

  final int? duration;
  final HttpDetails http;
  final List<String>? outboundRequests;

  DDApiLogRequest({
    required this.http,
    required super.apiKey,
    required super.loggingUrl,
    required super.statusCategory,
    required super.timestamp,
    required super.requestId,
    required super.traceId,
    required super.hostname,
    required super.message,
    required super.service,
    required super.source,
    required super.tags,
    required this.type,
    super.connectTimeoutMs,
    super.receiveTimeoutMs,
    super.environment,
    super.errors,
    this.duration,
    this.outboundRequests,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'type': type.name,
      'http': http.toJson(),
      if (duration != null) 'duration': duration!,
      if (outboundRequests != null) 'outbound_requests': outboundRequests!,
    };
  }

  @override
  DDApiLogRequest copyWith({
    HttpDetails? http,
    String? apiKey,
    String? loggingUrl,
    String? timestamp,
    String? requestId,
    String? traceId,
    StatusCategory? statusCategory,
    String? source,
    String? tags,
    String? hostname,
    String? message,
    String? service,
    Map<String, dynamic>? environment,
    List<String>? errors,
    LogType? type,
    int? duration,
    List<String>? outboundRequests,
  }) {
    return DDApiLogRequest(
      http: http ?? this.http,
      apiKey: apiKey ?? this.apiKey,
      loggingUrl: loggingUrl ?? this.loggingUrl,
      timestamp: timestamp ?? this.timestamp,
      requestId: requestId ?? this.requestId,
      traceId: traceId ?? this.traceId,
      statusCategory: statusCategory ?? this.statusCategory,
      source: source ?? this.source,
      tags: tags ?? this.tags,
      hostname: hostname ?? this.hostname,
      message: message ?? this.message,
      service: service ?? this.service,
      environment: environment ?? this.environment,
      errors: errors ?? this.errors,
      type: type ?? this.type,
      duration: duration ?? this.duration,
      outboundRequests: outboundRequests ?? this.outboundRequests,
    );
  }
}
