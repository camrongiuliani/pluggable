import 'dart:async';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';
import 'package:pluggable_dart_server/pluggable_dart_server.dart';
import 'package:uuid/uuid.dart';

class FrogRequestMapper extends AsyncMapper<RequestContext, PHttpRequest> {
  FrogRequestMapper(super.mapper);

  static List<Mapper> all(PluggableMapper mapper) => [
    FrogRequestMapper(mapper),
    HttpMethodMapper(mapper),
    FormDataMapper(mapper),
    FormFileMapper(mapper),
  ];

  @override
  Future<PHttpRequest> mapAsync(RequestContext source) async {
    final data = await _resolveData(source);

    return PHttpRequest.withData(
      uri: source.request.uri,
      headers: source.request.headers,
      queryParameters: source.request.uri.queryParameters,
      requestId: source.request.headers['x-request-id'] ?? Uuid().v4(),
      data: switch (data) {
        FormData() => await mapper.mapAsync<FormData, PFormData>(data),
        _ => data,
      },
      method: mapper.map(source.request.method),
    );
  }

  Future<dynamic> _resolveData(RequestContext context) {
    final contentType = _extractContentType(context.request.headers);
    final isFormUrlEncoded = _isFormUrlEncoded(contentType);
    final isMultipartFormData = _isMultipartFormData(contentType);
    final isJson = _isJson(contentType);
    final isText = _isText(contentType);

    return switch (isFormUrlEncoded || isMultipartFormData) {
      true => context.request.formData(),
      false => switch (isJson) {
          true => context.request.json(),
          false => switch (isText) {
              true => context.request.body(),
              false => context.request.bytes().toFuture(),
            },
        },
    };
  }

  static ContentType? _extractContentType(Map<String, String> headers) {
    final contentTypeValue = headers[HttpHeaders.contentTypeHeader];
    if (contentTypeValue == null) return null;
    return ContentType.parse(contentTypeValue);
  }

  static final formUrlEncodedContentType = ContentType(
    'application',
    'x-www-form-urlencoded',
  );

  /// Content-Type: multipart/form-data
  static final multipartFormDataContentType = ContentType(
    'multipart',
    'form-data',
  );

  /// application: octet-stream
  static final octetStreamDataContentType = ContentType(
    'application',
    'octet-stream',
  );

  static bool _isText(ContentType? contentType) {
    if (contentType == null) return false;
    return contentType.primaryType == 'text' ||
        _isJson(contentType) ||
        _isFormUrlEncoded(contentType);
  }

  static bool _isJson(ContentType? contentType) {
    if (contentType == null) return false;
    return contentType.mimeType == ContentType.json.mimeType;
  }

  static bool _isFormUrlEncoded(ContentType? contentType) {
    if (contentType == null) return false;
    return contentType.mimeType == formUrlEncodedContentType.mimeType;
  }

  static bool _isMultipartFormData(ContentType? contentType) {
    if (contentType == null) return false;
    return contentType.mimeType == multipartFormDataContentType.mimeType;
  }
}

class HttpMethodMapper extends Mapper<HttpMethod, PHttpMethod> {
  HttpMethodMapper(super.mapper);

  @override
  PHttpMethod map(HttpMethod source) {
    return switch (source) {
      HttpMethod.put => PHttpMethod.put,
      HttpMethod.get => PHttpMethod.get,
      HttpMethod.post => PHttpMethod.post,
      HttpMethod.delete => PHttpMethod.delete,
      HttpMethod.patch => PHttpMethod.patch,
      HttpMethod.head => PHttpMethod.head,
      HttpMethod.options => PHttpMethod.options,
    };
  }
}

class FormDataMapper extends AsyncMapper<FormData, PFormData> {
  FormDataMapper(super.mapper);

  @override
  Future<PFormData> mapAsync(FormData source) async {
    final mappedFiles = <String, PFormFile>{};
    for (final entry in source.files.entries) {
      mappedFiles[entry.key] = await mapper.mapAsync(entry.value);
    }
    
    return PFormData(
      fields: source.fields,
      files: mappedFiles,
    );
  }
}

class FormFileMapper extends AsyncMapper<UploadedFile, PFormFile> {
  FormFileMapper(super.mapper);

  @override
  Future<PFormFile> mapAsync(UploadedFile source) async {
    return PFormFile(
      source.name,
      source.contentType,
      await source.readAsBytes(),
    );
  }
}

extension _FutureExt on Stream<List<int>> {
  Future<List<int>> toFuture() {
    Completer<List<int>> completer = Completer();

    List<int> bytes = [];

    listen(
      (chunk) {
        bytes.addAll(chunk);
      },
      onDone: () {
        completer.complete(bytes);
      },
    );

    return completer.future;
  }
}
