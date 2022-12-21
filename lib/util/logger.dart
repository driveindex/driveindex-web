import 'package:logging/logging.dart';

class Log {
  static final Logger _logger = Logger("DriveIndex");

  static void finest(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.finest(message, {error: error, stackTrace: stackTrace});
  }

  static void finer(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.finer(message, {error: error, stackTrace: stackTrace});
  }

  static void fine(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, {error: error, stackTrace: stackTrace});
  }

  static void info(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, {error: error, stackTrace: stackTrace});
  }

  static void warning(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, {error: error, stackTrace: stackTrace});
  }
}