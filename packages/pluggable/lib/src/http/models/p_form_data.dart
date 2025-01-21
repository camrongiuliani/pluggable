import 'dart:collection';

import 'package:pluggable/pluggable.dart';

/// {@template form_data}
/// The fields and files of received form data request.
/// {@endtemplate}
class PFormData with MapMixin<String, String> {
  /// {@macro form_data}
  const PFormData({
    required Map<String, String> fields,
    required Map<String, PFormFile> files,
  })  : _fields = fields,
        _files = files;

  final Map<String, String> _fields;

  final Map<String, PFormFile> _files;

  /// The fields that were submitted in the form.
  Map<String, String> get fields => Map.unmodifiable(_fields);

  /// The files that were uploaded in the form.
  Map<String, PFormFile> get files => Map.unmodifiable(_files);

  @override
  @Deprecated('Use `fields[key]` to retrieve values')
  String? operator [](Object? key) => _fields[key] ?? _files[key]?.toString();

  @override
  @Deprecated('Use `fields.keys` to retrieve field keys')
  Iterable<String> get keys => _fields.keys;

  @override
  @Deprecated('Use `fields.values` to retrieve field values')
  Iterable<String> get values => _fields.values;

  @override
  @Deprecated(
    'FormData should be immutable, in the future this will thrown an error',
  )
  void operator []=(String key, String value) => _fields[key] = value;

  @override
  @Deprecated(
    'FormData should be immutable, in the future this will thrown an error',
  )
  void clear() => _fields.clear();

  @override
  @Deprecated(
    'FormData should be immutable, in the future this will thrown an error',
  )
  String? remove(Object? key) => _fields.remove(key);

  // fromJson
  PFormData.fromJson(Map<String, dynamic> json)
      : _fields = Map<String, String>.from(json['fields']),
        _files = Map<String, PFormFile>.fromEntries(
          (json['files'] as List).map(
            (e) => MapEntry(
              e['key'],
              PFormFile.fromJson(e['value']),
            ),
          ),
        );

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'fields': _fields,
      'files': _files.entries.map((e) => {
        'key': e.key,
        'value': e.value.toJson(),
      }).toList(),
    };
  }

  // copyWith
  PFormData copyWith({
    Map<String, String>? fields,
    Map<String, PFormFile>? files,
  }) {
    return PFormData(
      fields: fields ?? _fields,
      files: files ?? _files,
    );
  }
}