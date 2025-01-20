import 'dart:async';

import 'package:pluggable_dart_server/pluggable_dart_server.dart';

typedef PServerHandler = FutureOr<PHttpResponse<T>> Function<T>(
  PHttpRequest request,
);
