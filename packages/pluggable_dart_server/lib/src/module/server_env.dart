import 'dart:convert';
import 'dart:io';

import 'package:pluggable/pluggable.dart';

/// Abstract class for managing server environment configuration.
///
/// This class provides a foundation for handling environment-specific
/// configuration in the Pluggable server. It supports reading configuration
/// from environment variables with fallback values and provides methods
/// for validating the configuration.
///
/// Example usage:
/// ```dart
/// class MyServerEnv extends ServerEnv {
///   MyServerEnv() : super('MY_APP');
///
///   @override
///   void validate() {
///     if (urlBase.isEmpty) {
///       throw Exception('URL base is required');
///     }
///   }
/// }
/// ```
abstract class ServerEnv {
  /// Environment variable key for the base URL.
  static const String _kEnvUrlBase = 'P_ENV_URL_BASE';

  /// Environment variable key for the URL path.
  static const String _kEnvUrlPath = 'P_ENV_URL_PATH';

  /// Environment variable key for base headers.
  static const String _kEnvHeaders = 'P_ENV_BASE_HEADERS';

  /// Environment variable keys for custom variables.
  static const String _kEnvVar1 = 'P_ENV_VAR_1';
  static const String _kEnvVar2 = 'P_ENV_VAR_2';
  static const String _kEnvVar3 = 'P_ENV_VAR_3';
  static const String _kEnvVar4 = 'P_ENV_VAR_4';
  static const String _kEnvVar5 = 'P_ENV_VAR_5';
  static const String _kEnvVar6 = 'P_ENV_VAR_6';
  static const String _kEnvVar7 = 'P_ENV_VAR_7';

  /// Environment variable keys for Redis configuration.
  static const String _kEnvRedisHost = 'P_ENV_REDIS_HOST';
  static const String _kEnvRedisPort = 'P_ENV_REDIS_PORT';
  static const String _kEnvRedisUser = 'P_ENV_REDIS_USER';
  static const String _kEnvRedisPw = 'P_ENV_REDIS_PW';

  /// Environment variable key for IDP host.
  static const String _kEnvIdpHost = 'P_ENV_IDP_HOST';

  /// Environment variable key for local development flag.
  static const String _kEnvIsLocal = 'P_ENV_IS_LOCAL';

  /// Environment variable keys for logging configuration.
  static const String _kEnvLoggingCredential = 'P_ENV_LOGGING_CREDENTIAL';
  static const String _kEnvLoggingUrl = 'P_ENV_LOGGING_URL';
  static const String _kRemoteLoggingEnabled = 'REMOTE_LOGGING_ENABLED';
  static const String _kLoggingLevel = 'LOGGING_LEVEL';

  /// Environment variable key for zone.
  static const String _kZone = 'ZONE';

  /// The name of this environment configuration.
  final String _name;

  /// Creates a new server environment configuration.
  const ServerEnv(this._name);

  /// Validates the environment configuration.
  ///
  /// Override this method to implement custom validation logic.
  void validate();

  /// Gets an environment variable as a string.
  ///
  /// Tries to find the variable with the environment name prefix first,
  /// then falls back to the raw key.
  String _getEnvStr(String key, [String def = '']) {
    final key1 = '${_name}_$key';
    final key2 = key;

    return Platform.environment[key1] ?? Platform.environment[key2] ?? def;
  }

  /// Gets an environment variable as an integer.
  ///
  /// Tries to find the variable with the environment name prefix first,
  /// then falls back to the raw key.
  int _getEnvInt(String key, [int def = 0]) {
    final key1 = '${_name}_$key';
    final key2 = key;

    return (Platform.environment[key1] ?? Platform.environment[key2] ?? def)
        as int;
  }

  /// Gets the name of this environment configuration.
  String get name => _name;

  /// Gets the base URL from environment variables.
  String get urlBase => _getEnvStr(_kEnvUrlBase);

  /// Gets the URL path from environment variables.
  String get urlPath => _getEnvStr(_kEnvUrlPath);

  /// Gets custom variable 1 from environment variables.
  String get var1 => _getEnvStr(_kEnvVar1);

  /// Gets custom variable 2 from environment variables.
  String get var2 => _getEnvStr(_kEnvVar2);

  /// Gets custom variable 3 from environment variables.
  String get var3 => _getEnvStr(_kEnvVar3);

  /// Gets custom variable 4 from environment variables.
  String get var4 => _getEnvStr(_kEnvVar4);

  /// Gets custom variable 5 from environment variables.
  String get var5 => _getEnvStr(_kEnvVar5);

  /// Gets custom variable 6 from environment variables.
  String get var6 => _getEnvStr(_kEnvVar6);

  /// Gets custom variable 7 from environment variables.
  String get var7 => _getEnvStr(_kEnvVar7);

  /// Gets the IDP host from environment variables.
  String get idpHost => _getEnvStr(_kEnvIdpHost);

  /// Gets the Redis host from environment variables.
  String get syncHost => _getEnvStr(_kEnvRedisHost, 'localhost');

  /// Gets the Redis username from environment variables.
  String get syncUsername => _getEnvStr(_kEnvRedisUser);

  /// Gets the Redis password from environment variables.
  String get syncPassword => _getEnvStr(_kEnvRedisPw);

  /// Gets the logging credential from environment variables.
  String get loggingCredential => _getEnvStr(_kEnvLoggingCredential);

  /// Gets the zone from environment variables.
  String get zone => _getEnvStr(_kZone);

  /// Gets the logging URL from environment variables.
  String get loggingUrl => _getEnvStr(_kEnvLoggingUrl);

  /// Gets whether this is a local development environment.
  bool get isLocal => _getEnvStr(_kEnvIsLocal) == 'true';

  /// Gets the Redis port from environment variables.
  int get syncPort => int.parse(
        _getEnvStr(_kEnvRedisPort, '6379'),
      );

  /// Gets whether remote logging is enabled.
  bool get remoteLoggingEnabled =>
      _getEnvStr(_kRemoteLoggingEnabled).toLowerCase() == 'true';

  /// Gets the complete URL by combining base URL and path.
  String get url {
    return [
      urlBase,
      urlPath,
    ].join('/');
  }

  /// Gets the raw headers string from environment variables.
  String get rawHeaders => _getEnvStr(_kEnvHeaders, '{}');

  /// Gets the parsed headers from environment variables.
  ///
  /// Returns an empty map if parsing fails.
  Map<String, String> get headers {
    try {
      return (jsonDecode(
        _getEnvStr(_kEnvHeaders, '{}'),
      ) as Map<String, dynamic>)
          .map((key, value) {
        return MapEntry<String, String>(key, value);
      });
    } catch (e) {
      Pluggable.logger.e(
        e.toString(),
        err: e,
        stackTrace: StackTrace.current,
        tag: '$runtimeType',
      );
      return {};
    }
  }
}
