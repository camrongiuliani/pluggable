import 'package:pluggable/pluggable.dart';

import 'models.dart';

class HttpDetails {
  final String url;
  final int? statusCode;
  final String? statusMessage;
  final PHttpMethod method;
  final StatusCategory statusCategory;
  final int? statusSubCategory;
  final UrlDetails urlDetails;
  final RequestDetails request;
  final ResponseDetails? response;

  HttpDetails({
    required this.url,
    this.statusCode,
    this.statusMessage,
    this.statusSubCategory = 0,
    required this.method,
    required this.statusCategory,
    required this.urlDetails,
    required this.request,
    this.response,
  });

  Map<String, dynamic> toJson() {
    final data = {
      'url': url,
      'status_code': statusCode,
      'status_message': statusMessage,
      'method': method.value,
      'sub_status_code': statusSubCategory,
      'status_category': statusCategory.name,
      'url_details': urlDetails.toJson(),
      'request': request.toJson(),
    };

    if (response != null) data['response'] = response!.toJson();

    return data;
  }

  // copyWith
  HttpDetails copyWith({
    String? url,
    int? statusCode,
    String? statusMessage,
    int? statusSubCategory,
    PHttpMethod? method,
    StatusCategory? statusCategory,
    UrlDetails? urlDetails,
    RequestDetails? request,
    ResponseDetails? response,
  }) {
    return HttpDetails(
      url: url ?? this.url,
      statusCode: statusCode ?? this.statusCode,
      statusMessage: statusMessage ?? this.statusMessage,
      statusSubCategory: statusSubCategory ?? this.statusSubCategory,
      method: method ?? this.method,
      statusCategory: statusCategory ?? this.statusCategory,
      urlDetails: urlDetails ?? this.urlDetails,
      request: request ?? this.request,
      response: response ?? this.response,
    );
  }
}
