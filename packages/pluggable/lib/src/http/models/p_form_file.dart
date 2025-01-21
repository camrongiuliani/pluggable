import 'dart:io';

/// {@template uploaded_file}
/// The uploaded file of a form data request.
/// {@endtemplate}
class PFormFile {
  /// {@macro uploaded_file}
  const PFormFile(
      this.name,
      this.contentType,
      this._byteStream,
      );

  // fromJson
  PFormFile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        contentType = ContentType.parse(json['contentType']),
        _byteStream = Stream<List<int>>.fromIterable(
          (json['byteStream'] as List).map((e) => List<int>.from(e)),
        );

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contentType': contentType.toString(),
      'byteStream': _byteStream.map((e) => e.toList()).toList(),
    };
  }

  // copyWith
  PFormFile copyWith({
    String? name,
    ContentType? contentType,
    Stream<List<int>>? byteStream,
  }) {
    return PFormFile(
      name ?? this.name,
      contentType ?? this.contentType,
      byteStream ?? _byteStream,
    );
  }

  /// The name of the uploaded file.
  final String name;

  /// The type of the uploaded file.
  final ContentType contentType;

  final Stream<List<int>> _byteStream;

  /// Read the content of the file as a list of bytes.
  ///
  /// Can only be called once.
  Future<List<int>> readAsBytes() async {
    return (await _byteStream.toList())
        .fold<List<int>>([], (p, e) => p..addAll(e));
  }

  /// Open the content of the file as a stream of bytes.
  ///
  /// Can only be called once.
  Stream<List<int>> openRead() => _byteStream;

  @override
  String toString() {
    return '{ name: $name, contentType: $contentType }';
  }
}
