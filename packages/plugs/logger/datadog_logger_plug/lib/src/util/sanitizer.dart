import 'dart:convert';

class Sanitizer {
  /// Obfuscates sensitive information in the message.
  /// If the message contains a JSON string, it will be parsed and sanitized recursively.
  /// Keys in [maskedKeys] will have their values obfuscated.
  static String obfuscate(
      String message, {
        List<String> maskedKeys = const [],
      }) {
    for (int i = 0; i < message.length; i++) {
      final char = message[i];
      if (char == '{' || char == '[') {
        final jsonPart = message.substring(i);
        try {
          final decoded = jsonDecode(jsonPart);
          final prefix = message.substring(0, i);
          String sanitizedJson;

          if (decoded is Map<String, dynamic>) {
            final sanitizedMap = _sanitizeMap(decoded, maskedKeys);
            sanitizedJson = jsonEncode(sanitizedMap);
          } else if (decoded is List) {
            final sanitizedList = _sanitizeList(decoded, maskedKeys);
            sanitizedJson = jsonEncode(sanitizedList);
          } else {
            // This case might not be hit if jsonDecode works as expected for valid JSON,
            // but as a fallback, we obfuscate the string part.
            sanitizedJson = _obfuscateString(jsonPart);
          }
          return '$prefix$sanitizedJson';
        } catch (e) {
          // Not the start of a valid JSON, continue scanning.
        }
      }
    }

    // No JSON found in the message, just obfuscate the whole string.
    return _obfuscateString(message);
  }

  static Map<String, dynamic> _sanitizeMap(
      Map<String, dynamic> map,
      List<String> maskedKeys,
      ) {
    final sanitizedMap = <String, dynamic>{};
    map.forEach((key, value) {
      if (maskedKeys.contains(key)) {
        sanitizedMap[key] = _maskValue(value);
      } else if (value is Map<String, dynamic>) {
        sanitizedMap[key] = _sanitizeMap(value, maskedKeys);
      } else if (value is List) {
        sanitizedMap[key] = _sanitizeList(value, maskedKeys);
      } else if (value is String) {
        sanitizedMap[key] = _obfuscateString(value);
      } else {
        sanitizedMap[key] = value;
      }
    });
    return sanitizedMap;
  }

  static List<dynamic> _sanitizeList(
      List<dynamic> list,
      List<String> maskedKeys,
      ) {
    return list.map((item) {
      if (item is Map<String, dynamic>) {
        return _sanitizeMap(item, maskedKeys);
      } else if (item is List) {
        return _sanitizeList(item, maskedKeys);
      } else if (item is String) {
        return _obfuscateString(item);
      }
      return item;
    }).toList();
  }

  static dynamic _maskValue(dynamic value) {
    if (value is String) {
      return 'X' * value.length;
    }
    if (value is num) {
      return 0;
    }
    return value;
  }

  static String _obfuscateString(String message) {
    message = _obfuscateAccountNumbersStr(message);
    message = _obfuscateCreditCardNumbersStr(message);
    message = _obfuscateSocialSecurityNumbersStr(message);
    message = _obfuscateEINStr(message);
    message = _obfuscateITINStr(message);
    return message;
  }

  /// Obfuscate account numbers (typically 7 to 12 digits)
  static String _obfuscateAccountNumbersStr(String message) {
    return message.replaceAllMapped(
      RegExp(r'\b(\d{3,8})(\d{4})\b'),
          (match) => '${'*' * match.group(1)!.length}${match.group(2)}',
    );
  }

  /// Obfuscate credit card numbers (typically 16 digits)
  static String _obfuscateCreditCardNumbersStr(String message) {
    return message.replaceAllMapped(
      RegExp(r'\b(\d{12})(\d{4})\b'),
          (match) => '${'*' * 12}${match.group(2)}',
    );
  }

  /// Obfuscate social security numbers (9 digits)
  static String _obfuscateSocialSecurityNumbersStr(String message) {
    return message.replaceAllMapped(
      RegExp(r'\b(\d{5})(\d{4})\b'),
          (match) => '${'*' * 5}${match.group(2)}',
    );
  }

  /// Obfuscate EIN numbers (9 digits in the format XX-XXXXXXX)
  static String _obfuscateEINStr(String message) {
    return message.replaceAllMapped(
      RegExp(r'\b(\d{2})-(\d{7})\b'),
          (match) => '${'*' * 2}-${'*' * 7}',
    );
  }

  /// Obfuscate ITIN numbers (9 digits in the format XXX-XX-XXXX)
  static String _obfuscateITINStr(String message) {
    return message.replaceAllMapped(
      RegExp(r'\b(\d{3})-(\d{2})-(\d{4})\b'),
          (match) => '${'*' * 3}-${'*' * 2}-${'*' * 4}',
    );
  }
}
