/// Custom exception hierarchy for KataPlay
/// Provides structured error handling across all layers
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() => 'AppException($code): $message';
}

/// Storage-related errors (Hive read/write failures)
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code = 'STORAGE_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Data not found in local storage
class DataNotFoundException extends AppException {
  const DataNotFoundException({
    required super.message,
    super.code = 'DATA_NOT_FOUND',
    super.originalError,
    super.stackTrace,
  });
}

/// Validation errors (invalid user input, corrupt data)
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Game-specific errors
class GameException extends AppException {
  const GameException({
    required super.message,
    super.code = 'GAME_ERROR',
    super.originalError,
    super.stackTrace,
  });
}

/// Network connectivity errors (for future cloud sync)
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code = 'NETWORK_ERROR',
    super.originalError,
    super.stackTrace,
  });
}
