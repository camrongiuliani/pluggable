import 'dart:io';

import 'package:pluggable/pluggable.dart';
import 'package:dio/dio.dart';

class DioFormFileMapper extends Mapper<MultipartFile, PFormFile> {
  DioFormFileMapper(super.mapper);

  @override
  PFormFile map(MultipartFile source) {
    return PFormFile(
      source.filename ?? 'file',
      ContentType.parse(
        source.contentType?.mimeType ?? 'application/octet-stream',
      ),
      source.clone().finalize(),
    );
  }
}