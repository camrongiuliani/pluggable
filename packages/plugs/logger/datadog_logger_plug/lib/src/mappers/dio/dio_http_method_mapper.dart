import 'package:pluggable/pluggable.dart';

class DioHttpMethodMapper extends Mapper<String, PHttpMethod> {
  DioHttpMethodMapper(super.mapper);

  @override
  PHttpMethod map(String source) {
    return PHttpMethod.parse(source.toUpperCase());
  }
}