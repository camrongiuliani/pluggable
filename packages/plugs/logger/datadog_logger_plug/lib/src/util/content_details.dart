import 'dart:io';

class ContentDetails {

  final Map<String, String> headers;

  ContentDetails.fromHeaders(this.headers);

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

  ContentType? get contentType {
    final contentTypeValue = headers[HttpHeaders.contentTypeHeader];
    if (contentTypeValue == null) return null;
    return ContentType.parse(contentTypeValue);
  }

  bool get isMultipartFormData {
    return contentType?.mimeType == multipartFormDataContentType.mimeType;
  }

  bool get isFormUrlEncoded {
    return contentType?.mimeType == formUrlEncodedContentType.mimeType;
  }

  bool get isJson {
    return contentType?.mimeType == ContentType.json.mimeType;
  }

  bool get isStream {
    return contentType?.mimeType == octetStreamDataContentType.mimeType;
  }
}
