import 'dart:developer';

class LoggerService {
  LoggerService._privateConstructor();

  static final LoggerService instance = LoggerService._privateConstructor();

  void e(String message, {Object? error, StackTrace? stackTrace}) {
    log(
      'ERROR: $message',
      error: error,
      stackTrace: stackTrace,
      time: DateTime.now(),
      level: 1000, // 1000 corresponds to Level.SEVERE in Dart's log function
    );
  }

  void d(String message) {
    log(
      'DEBUG: $message',
      level: 500,
    ); // 500 corresponds to Level.FINE in Dart's log function
  }
}
