import 'dart:convert';
import 'dart:io';

import 'package:pluggable/pluggable.dart';

abstract class ServerEnv {
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

  final String _name;

  const ServerEnv(this._name);

  void validate();

  String _getEnvStr(String key, [String def = '']) {
    final key1 = '${_name}_$key';
    final key2 = key;

    return Platform.environment[key1] ?? Platform.environment[key2] ?? def;
  }

  int _getEnvInt(String key, [int def = 0]) {
    final key1 = '${_name}_$key';
    final key2 = key;

    return (Platform.environment[key1] ?? Platform.environment[key2] ?? def)
        as int;
  }

  String get name => _name;

  String get urlBase => _getEnvStr(_kEnvUrlBase);

  String get urlPath => _getEnvStr(_kEnvUrlPath);

  String get var1 => _getEnvStr(_kEnvVar1);

  String get var2 => _getEnvStr(_kEnvVar2);

  String get var3 => _getEnvStr(_kEnvVar3);

  String get var4 => _getEnvStr(_kEnvVar4);

  String get var5 => _getEnvStr(_kEnvVar5);

  String get var6 => _getEnvStr(_kEnvVar6);

  String get var7 => _getEnvStr(_kEnvVar7);

  String get idpHost => _getEnvStr(_kEnvIdpHost);

  String get syncHost => _getEnvStr(_kEnvRedisHost, 'localhost');

  String get syncUsername => _getEnvStr(_kEnvRedisUser);

  String get syncPassword => _getEnvStr(_kEnvRedisPw);

  String get loggingCredential => _getEnvStr(_kEnvLoggingCredential);

  String get zone => _getEnvStr(_kZone);

  String get loggingUrl => _getEnvStr(_kEnvLoggingUrl);

  bool get isLocal => _getEnvStr(_kEnvIsLocal) == 'true';

  int get syncPort => int.parse(
        _getEnvStr(_kEnvRedisPort, '6379'),
      );

  bool get remoteLoggingEnabled =>
      _getEnvStr(_kRemoteLoggingEnabled).toLowerCase() == 'true';

  // SavLogLevelEnum get loggingLevel =>
  //     SavLogLevelEnum.maybeParse(_getEnvStr(_kLoggingLevel)) ??
  //         SavLogLevelEnum.info;

  String get url {
    return [
      urlBase,
      urlPath,
    ].join('/');
  }

  String get rawHeaders => _getEnvStr(_kEnvHeaders, '{}');

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
