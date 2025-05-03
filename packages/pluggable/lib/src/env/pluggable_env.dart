/// Abstract base class for environment configuration in the Pluggable system.
/// 
/// This class provides a standardized way to access and manage environment variables
/// across different parts of the application. It supports both prefixed and non-prefixed
/// environment variables, with fallback values for missing configurations.
/// 
/// Example usage:
/// ```dart
/// class MyEnvironment extends PluggableEnv {
///   MyEnvironment() : super('MY_APP');
///   
///   @override
///   void validate() {
///     // Validate required environment variables
///   }
/// }
/// ```

import 'dart:convert';
import 'dart:io';

import 'package:pluggable/pluggable.dart';

abstract class PluggableEnv {
  // Environment variable keys for various configuration options
  static const String _kEnvUrlBase = 'P_ENV_URL_BASE';
  static const String _kEnvUrlPath = 'P_ENV_URL_PATH';
  static const String _kEnvHeaders = 'P_ENV_BASE_HEADERS';
  static const String _kEnvVar1 = 'P_ENV_VAR_1';
  static const String _kEnvVar2 = 'P_ENV_VAR_2';
  static const String _kEnvVar3 = 'P_ENV_VAR_3';
  static const String _kEnvVar4 = 'P_ENV_VAR_4';
  static const String _kEnvVar5 = 'P_ENV_VAR_5';
  static const String _kEnvVar6 = 'P_ENV_VAR_6';
  static const String _kEnvVar7 = 'P_ENV_VAR_7';
  static const String _kEnvRedisHost = 'P_ENV_REDIS_HOST';
  static const String _kEnvRedisPort = 'P_ENV_REDIS_PORT';
  static const String _kEnvRedisUser = 'P_ENV_REDIS_USER';
  static const String _kEnvRedisPw = 'P_ENV_REDIS_PW';
  static const String _kEnvIdpHost = 'P_ENV_IDP_HOST';
  static const String _kEnvIsLocal = 'P_ENV_IS_LOCAL';
  static const String _kEnvLoggingCredential = 'P_ENV_LOGGING_CREDENTIAL';
  static const String _kEnvLoggingUrl = 'P_ENV_LOGGING_URL';
  static const String _kRemoteLoggingEnabled = 'REMOTE_LOGGING_ENABLED';
  static const String _kLoggingLevel = 'LOGGING_LEVEL';
  static const String _kZone = 'ZONE';

  /// The name prefix for environment variables
  final String _name;

  /// Creates a new PluggableEnv instance with the specified name prefix
  const PluggableEnv(this._name);

  /// Validates the environment configuration
  /// 
  /// Override this method to implement custom validation logic
  /// for required environment variables
  void validate();

  /// Gets a string value from environment variables
  /// 
  /// Tries to find the value using both prefixed and non-prefixed keys,
  /// falling back to the default value if not found
  String _getEnvStr(String key, [String def = '']) {
    final key1 = '${_name}_$key';
    final key2 = key;

    return Platform.environment[key1] ?? Platform.environment[key2] ?? def;
  }

  /// Gets an integer value from environment variables
  /// 
  /// Tries to find the value using both prefixed and non-prefixed keys,
  /// falling back to the default value if not found
  int _getEnvInt(String key, [int def = 0]) {
    final key1 = '${_name}_$key';
    final key2 = key;

    return (Platform.environment[key1] ?? Platform.environment[key2] ?? def)
        as int;
  }

  /// Gets the environment name prefix
  String get name => _name;

  /// Gets the base URL from environment variables
  String get urlBase => _getEnvStr(_kEnvUrlBase);

  /// Gets the URL path from environment variables
  String get urlPath => _getEnvStr(_kEnvUrlPath);

  /// Gets the first custom variable from environment variables
  String get var1 => _getEnvStr(_kEnvVar1);

  /// Gets the second custom variable from environment variables
  String get var2 => _getEnvStr(_kEnvVar2);

  /// Gets the third custom variable from environment variables
  String get var3 => _getEnvStr(_kEnvVar3);

  /// Gets the fourth custom variable from environment variables
  String get var4 => _getEnvStr(_kEnvVar4);

  /// Gets the fifth custom variable from environment variables
  String get var5 => _getEnvStr(_kEnvVar5);

  /// Gets the sixth custom variable from environment variables
  String get var6 => _getEnvStr(_kEnvVar6);

  /// Gets the seventh custom variable from environment variables
  String get var7 => _getEnvStr(_kEnvVar7);

  /// Gets the IDP host from environment variables
  String get idpHost => _getEnvStr(_kEnvIdpHost);

  /// Gets the Redis host from environment variables, defaulting to 'localhost'
  String get syncHost => _getEnvStr(_kEnvRedisHost, 'localhost');

  /// Gets the Redis username from environment variables
  String get syncUsername => _getEnvStr(_kEnvRedisUser);

  /// Gets the Redis password from environment variables
  String get syncPassword => _getEnvStr(_kEnvRedisPw);

  /// Gets the logging credential from environment variables
  String get loggingCredential => _getEnvStr(_kEnvLoggingCredential);

  /// Gets the zone from environment variables
  String get zone => _getEnvStr(_kZone);

  /// Gets the logging URL from environment variables
  String get loggingUrl => _getEnvStr(_kEnvLoggingUrl);

  /// Checks if the environment is local
  bool get isLocal => _getEnvStr(_kEnvIsLocal) == 'true';

  /// Gets the Redis port from environment variables, defaulting to 6379
  int get syncPort => int.parse(
        _getEnvStr(_kEnvRedisPort, '6379'),
      );

  /// Checks if remote logging is enabled
  bool get remoteLoggingEnabled =>
      _getEnvStr(_kRemoteLoggingEnabled).toLowerCase() == 'true';

  /// Gets the complete URL by combining base URL and path
  String get url {
    return [
      urlBase,
      urlPath,
    ].join('/');
  }

  /// Gets the raw headers string from environment variables
  String get rawHeaders => _getEnvStr(_kEnvHeaders, '{}');

  /// Gets the parsed headers map from environment variables
  /// 
  /// Attempts to parse the headers JSON string into a map.
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
