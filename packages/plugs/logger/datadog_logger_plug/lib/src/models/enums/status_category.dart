enum StatusCategory {
  ok,
  error,
  info,
  warn;

  static StatusCategory fromString(String value) {
    switch (value.toLowerCase()) {
      case 'ok':
        return StatusCategory.ok;
      case 'error':
        return StatusCategory.error;
      case 'info':
        return StatusCategory.info;
      case 'warn':
        return StatusCategory.warn;
      default:
        throw ArgumentError('Unknown status category: $value');
    }
  }

  static fromHttpStatusCode(int? statusCode) {
    if (statusCode == null) {
      return StatusCategory.error;
    }

    if (statusCode >= 200 && statusCode < 300) {
      return StatusCategory.ok;
    } else {
      return StatusCategory.error;
    }
  }

  @override
  String toString() {
    return name;
  }

  bool get isOk => this == StatusCategory.ok;
  bool get isError => this == StatusCategory.error;
  bool get isInfo => this == StatusCategory.info;
  bool get isWarn => this == StatusCategory.warn;
}
