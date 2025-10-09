import 'package:pluggable/pluggable.dart';
import 'package:dio/dio.dart';

class DioFormDataMapper extends Mapper<FormData, PFormData> {
  DioFormDataMapper(super.mapper);

  @override
  PFormData map(FormData source) {
    return PFormData(
      fields: Map.fromEntries(source.fields),
      files: Map.fromEntries(source.files).map((key, file) {
        return MapEntry(key, mapper.map(file));
      }),
    );
  }
}