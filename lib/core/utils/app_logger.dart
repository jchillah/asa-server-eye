// core/utils/app_logger.dart
import 'package:flutter/foundation.dart';

enum LogLevel { debug, info, warning, error }

abstract final class AppLogger {
  static void debug(String tag, String message) {
    _print(LogLevel.debug, tag, message);
  }

  static void info(String tag, String message) {
    _print(LogLevel.info, tag, message);
  }

  static void warning(String tag, String message) {
    _print(LogLevel.warning, tag, message);
  }

  static void error(
    String tag,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final buffer = StringBuffer('[ERROR][$tag] $message');

    if (error != null) {
      buffer.write(' | error=$error');
    }

    debugPrint(buffer.toString());

    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  static void _print(LogLevel level, String tag, String message) {
    final prefix = switch (level) {
      LogLevel.debug => 'DEBUG',
      LogLevel.info => 'INFO',
      LogLevel.warning => 'WARN',
      LogLevel.error => 'ERROR',
    };

    debugPrint('[$prefix][$tag] $message');
  }
}
