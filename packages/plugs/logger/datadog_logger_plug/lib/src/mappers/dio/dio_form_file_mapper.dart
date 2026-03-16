import 'dart:io';

import 'package:pluggable/pluggable.dart';
import 'package:dio/dio.dart';

class DioFormFileMapper extends AsyncMapper<MultipartFile, PFormFile> {
  DioFormFileMapper(super.mapper);

  @override
  Future<PFormFile> mapAsync(MultipartFile source) async {
    return PFormFile(
      source.filename ?? 'file',
      ContentType.parse(
        source.contentType?.mimeType ?? 'application/octet-stream',
      ),
      await source.clone().finalize().fold<List<int>>(<int>[], (p, e) => p..addAll(e)),
    );
  }
}
