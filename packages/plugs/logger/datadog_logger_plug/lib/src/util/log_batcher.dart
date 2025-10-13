import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:datadog_logger_plug/src/util/sanitizer.dart';
import 'package:dio/dio.dart';

import '../models/log_request.dart';

// Check for web environment
const bool kIsWeb = identical(0, 0.0);

const List<String> _maskedKeys = [
  'password',
  'DD-API-KEY',
  'token',
  'authorization',
  'access_token',
  'auth_token',
  'ssn',
  'ein',
  'itin',
  'tin',
  'social_security_number',
  'account_number',
  'credit_card_number',
  'dob',
  'client_secret',
  'api_key',
  'apiKey',
  'secret',
];

class LogBatcher {
  final String _apiKey;
  final String _loggingUrl;
  final Duration _batchInterval;
  final int _batchSize;
  final int _connectTimeoutMs;
  final int _receiveTimeoutMs;

  final List<DDLogRequest> _logQueue = [];
  Timer? _timer;

  // For non-web (Isolate)
  Isolate? _isolate;
  SendPort? _sendPort;

  LogBatcher({
    required String apiKey,
    required String loggingUrl,
    Duration? batchInterval,
    int? batchSize,
    int connectTimeoutMs = 60000,
    int receiveTimeoutMs = 60000,
  })  : _apiKey = apiKey,
        _loggingUrl = loggingUrl,
        _batchInterval = batchInterval ?? const Duration(seconds: 5),
        _batchSize = batchSize ?? 100,
        _connectTimeoutMs = connectTimeoutMs,
        _receiveTimeoutMs = receiveTimeoutMs {
    if (kIsWeb) {
      _startTimer();
    } else {
      _initIsolate();
    }
  }

  Future<void> _initIsolate() async {
    final receivePort = ReceivePort();
    _isolate = await Isolate.spawn(_isolateEntryPoint, receivePort.sendPort);

    final message = await receivePort.first;
    if (message is SendPort) {
      _sendPort = message;
      _sendPort?.send({
        'apiKey': _apiKey,
        'loggingUrl': _loggingUrl,
        'batchIntervalSeconds': _batchInterval.inSeconds,
        'batchSize': _batchSize,
        'connectTimeoutMs': _connectTimeoutMs,
        'receiveTimeoutMs': _receiveTimeoutMs,
      });
    }
  }

  void addLog(DDLogRequest log) {
    bool isStream = log is DDApiLogRequest && log.http.request.body is Stream;

    if (kIsWeb || isStream) {
      _logQueue.add(
        log.copyWith(
          message: Sanitizer.obfuscate(log.message, maskedKeys: _maskedKeys),
        ),
      );
      if (_logQueue.length >= _batchSize) {
        _flush();
      }
    } else {
      _sendPort?.send(log);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(_batchInterval, (timer) {
      if (_logQueue.isNotEmpty) {
        _flush();
      }
    });
  }

  Future<void> _flush() async {
    if (_logQueue.isEmpty) {
      return;
    }

    try {
      final batch = List<DDLogRequest>.from(_logQueue).map((e) {
        return switch (e) {
          DDApiLogRequest r => r.copyWith(
              message: Sanitizer.obfuscate(r.message, maskedKeys: _maskedKeys),
              http: r.http.copyWith(
                request: r.http.request.copyWith(
                  body: switch (r.http.request.body) {
                    String s => Sanitizer.obfuscate(s, maskedKeys: _maskedKeys),
                    Map<String, dynamic> m => Sanitizer.obfuscateMap(
                        m,
                        maskedKeys: _maskedKeys,
                      ),
                    _ => r.http.request.body,
                  },
                ),
              ),
            ),
          DDLogRequest r => r.copyWith(
              message: Sanitizer.obfuscate(r.message, maskedKeys: _maskedKeys),
            ),
        };
      }).toList();

      _logQueue.clear();

      await _postBatch(batch);
    } catch (e, s) {
      // Never rethrow any error. We don't want to break the app because of a log.
      // ignore: avoid_print
      print('Error flushing logs: $e\n$s');
    } finally {
      if (kIsWeb) {
        _resetTimer();
      }
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _startTimer();
  }

  Future<void> _postBatch(List<DDLogRequest> batch) async {
    if (batch.isEmpty) {
      return;
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: _loggingUrl,
          headers: {'DD-API-KEY': _apiKey},
          connectTimeout: Duration(milliseconds: _connectTimeoutMs),
          receiveTimeout: Duration(milliseconds: _receiveTimeoutMs),
        ),
      );
      // Datadog batch API expects a newline-separated JSON array
      final data = jsonEncode(batch.map((log) => log.toJson()).toList());
      await dio.post('/logs', data: data);
    } catch (e, s) {
      // Never rethrow any error. We don't want to break the app because of a log.
      // ignore: avoid_print
      print('Error sending logs: $e\n$s');
      // Re-queue failed logs
      // _logQueue.insertAll(0, batch);
    }
  }

  Future<void> dispose() async {
    if (kIsWeb) {
      _timer?.cancel();
      await _flush();
    } else {
      if (_sendPort != null && _isolate != null) {
        final completer = Completer<void>();
        final port = ReceivePort();
        port.listen((message) {
          if (message == 'disposed') {
            port.close();
            _isolate?.kill(priority: Isolate.immediate);
            _isolate = null;
            completer.complete();
          }
        });

        _sendPort!.send({'command': 'dispose', 'replyPort': port.sendPort});
        await completer.future;
      } else {
        _isolate?.kill(priority: Isolate.immediate);
        _isolate = null;
      }
    }
  }
}

// Isolate entry point
void _isolateEntryPoint(SendPort mainSendPort) {
  runZonedGuarded(
    () {
      final isolateReceivePort = ReceivePort();
      mainSendPort.send(isolateReceivePort.sendPort);

      late final String apiKey;
      late final String loggingUrl;
      late final Duration batchInterval;
      late final int batchSize;
      late final int connectTimeoutMs;
      late final int receiveTimeoutMs;

      final logQueue = <DDLogRequest>[];
      Timer? timer;
      StreamSubscription? subscription;
      var configured = false;

      Future<void> postBatch(List<DDLogRequest> batch) async {
        if (batch.isEmpty) return;
        try {
          final dio = Dio(
            BaseOptions(
              baseUrl: loggingUrl,
              headers: {'DD-API-KEY': apiKey},
              connectTimeout: Duration(milliseconds: connectTimeoutMs),
              receiveTimeout: Duration(milliseconds: receiveTimeoutMs),
            ),
          );
          final data = jsonEncode(batch.map((log) => log.toJson()).toList());

          await dio.post('/logs', data: data);
        } catch (e, s) {
          // ignore: avoid_print
          print('Error sending logs from isolate: $e\n$s');
        }
      }

      Future<void> flush() async {
        if (logQueue.isEmpty) return;
        final batch = List<DDLogRequest>.from(logQueue);
        logQueue.clear();
        await postBatch(batch);
      }

      void resetTimer() {
        timer?.cancel();
        timer = Timer.periodic(batchInterval, (_) => flush());
      }

      subscription = isolateReceivePort.listen((message) async {
        try {
          if (!configured) {
            // The first message is the configuration.
            final config = message as Map;
            apiKey = config['apiKey'] as String;
            loggingUrl = config['loggingUrl'] as String;
            batchInterval =
                Duration(seconds: config['batchIntervalSeconds'] as int);
            batchSize = config['batchSize'] as int;
            connectTimeoutMs = config['connectTimeoutMs'] as int;
            receiveTimeoutMs = config['receiveTimeoutMs'] as int;
            configured = true;

            resetTimer(); // Start the timer now that we have the interval.
            return;
          }
          // Subsequent messages
          if (message is DDLogRequest) {
            logQueue.add(
              message.copyWith(
                message: Sanitizer.obfuscate(
                  message.message,
                  maskedKeys: _maskedKeys,
                ),
              ),
            );
            if (logQueue.length >= batchSize) {
              await flush();
              resetTimer();
            }
          } else if (message is Map && message['command'] == 'dispose') {
            final replyPort = message['replyPort'] as SendPort;
            timer?.cancel();
            await flush();
            replyPort.send('disposed');

            // Clean up
            await subscription?.cancel();
            isolateReceivePort.close();
          }
        } catch (e, s) {
          // ignore: avoid_print
          print('Error in isolate: $e\n$s');
        }
      });
    },
    (e, s) {
      // ignore: avoid_print
      print('Unhandled error in isolate: $e\n$s');
    },
  );
}
