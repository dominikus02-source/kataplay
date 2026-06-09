import 'dart:async';

import 'package:flutter/foundation.dart';

import 'app_exception.dart';

/// Global error handler for KataPlay
/// Catches and processes all unhandled errors in the app
class KataPlayErrorHandler {
  KataPlayErrorHandler._();

  /// Initialize global error handlers
  static void init() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
    };

    // Catch async errors outside Flutter
    runZonedGuarded(
      () => _log('KataPlayErrorHandler initialized'),
      (error, stackTrace) {
        _handleAsyncError(error, stackTrace);
      },
    );
  }

  /// Handle Flutter framework errors (rendering, layout, etc.)
  static void _handleFlutterError(FlutterErrorDetails details) {
    if (kDebugMode) {
      // In debug mode, still show the red error screen
      FlutterError.dumpErrorToConsole(details);
    }
    _log(
      'Flutter Error: ${details.exceptionAsString()}',
      stackTrace: details.stack,
    );
  }

  /// Handle async errors not caught by Flutter
  static void _handleAsyncError(Object error, StackTrace stackTrace) {
    _log('Async Error: $error', stackTrace: stackTrace);
  }

  /// Convert any error to a user-friendly message
  static String getUserMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }
    // Generic fallback - don't expose internal errors to kids
    return 'Terjadi kesalahan. Coba lagi ya!';
  }

  /// Convert any error to AppException
  static AppException toAppException(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) return error;
    return AppException(
      message: 'Terjadi kesalahan yang tidak terduga',
      code: 'UNKNOWN_ERROR',
      originalError: error,
      stackTrace: stackTrace,
    );
  }

  /// Safe execution wrapper - catches errors and returns result or null
  static T? safeExecute<T>(T Function() fn) {
    try {
      return fn();
    } catch (e, st) {
      _log('SafeExecute caught: $e', stackTrace: st);
      return null;
    }
  }

  /// Safe async execution wrapper
  static Future<T?> safeExecuteAsync<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } catch (e, st) {
      _log('SafeExecuteAsync caught: $e', stackTrace: st);
      return null;
    }
  }

  /// Internal logging
  static void _log(String message, {StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[KataPlay Error] $message');
      if (stackTrace != null) {
        debugPrint(stackTrace.toString());
      }
    }
    // TODO: In production, send to Crashlytics
  }
}
