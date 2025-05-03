/// Form file model for the Pluggable system.
/// 
/// This class represents a file uploaded in a form data request.
/// It provides methods to read the file content as bytes or as a stream.
/// 
/// Example usage:
/// ```dart
/// final file = PFormFile(
///   name: 'document.pdf',
///   contentType: ContentType('application', 'pdf'),
///   byteStream: Stream.fromIterable([/* file bytes */]),
/// );
/// 
/// // Read the entire file as bytes
/// final bytes = await file.readAsBytes();
/// 
/// // Or read the file as a stream
/// final stream = file.openRead();
/// ```

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

  /// Creates a form file instance from JSON
  PFormFile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        contentType = ContentType.parse(json['contentType']),
        _byteStream = Stream<List<int>>.fromIterable(
          (json['byteStream'] as List).map((e) => List<int>.from(e)),
        );

  /// Converts the form file to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contentType': contentType.toString(),
      'byteStream': _byteStream.map((e) => e.toList()).toList(),
    };
  }

  /// Creates a copy of this form file with the specified fields replaced
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

  /// Internal stream of file bytes
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
