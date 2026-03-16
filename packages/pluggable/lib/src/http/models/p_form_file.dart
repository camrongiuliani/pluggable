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
///   bytes: [/* file bytes */],
/// );
/// 
/// // Read the entire file as bytes
/// final bytes = file.bytes;
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
      this.bytes,
      );

  /// Creates a form file instance from JSON
  PFormFile.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        contentType = ContentType.parse(json['contentType']),
        bytes = List<int>.from(json['bytes']);

  /// Converts the form file to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contentType': contentType.toString(),
      'bytes': bytes,
    };
  }

  /// Creates a copy of this form file with the specified fields replaced
  PFormFile copyWith({
    String? name,
    ContentType? contentType,
    List<int>? bytes,
  }) {
    return PFormFile(
      name ?? this.name,
      contentType ?? this.contentType,
      bytes ?? this.bytes,
    );
  }

  /// The name of the uploaded file.
  final String name;

  /// The type of the uploaded file.
  final ContentType contentType;

  /// Internal file bytes
  final List<int> bytes;

  /// Read the content of the file as a list of bytes.
  Future<List<int>> readAsBytes() async => bytes;

  /// Open the content of the file as a stream of bytes.
  Stream<List<int>> openRead() => Stream.value(bytes);

  @override
  String toString() {
    return '{ name: $name, contentType: $contentType }';
  }
}
