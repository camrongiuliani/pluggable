enum LogType {
  inboundRequest,
  outboundRequest;

  static LogType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'inboundRequest':
        return LogType.inboundRequest;
      case 'outboundRequest':
        return LogType.outboundRequest;
      default:
        throw ArgumentError('Unknown log type: $value');
    }
  }

  @override
  String toString() {
    return name;
  }

  bool get isInboundRequest => this == LogType.inboundRequest;
  bool get isOutboundRequest => this == LogType.outboundRequest;
}
