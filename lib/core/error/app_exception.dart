import 'package:equatable/equatable.dart';

/// Base exception class for the app
abstract class AppException extends Equatable {
  const AppException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, [super.code]);

  factory NetworkException.noConnection() {
    return const NetworkException('No internet connection');
  }

  factory NetworkException.timeout() {
    return const NetworkException('Request timeout');
  }

  factory NetworkException.serverError([String? code]) {
    return NetworkException('Server error occurred', code);
  }
}

/// Authentication-related exceptions
class AuthException extends AppException {
  const AuthException(super.message, [super.code]);

  factory AuthException.invalidCredentials() {
    return const AuthException('Invalid credentials');
  }

  factory AuthException.userNotFound() {
    return const AuthException('User not found');
  }

  factory AuthException.weakPassword() {
    return const AuthException('Password is too weak');
  }

  factory AuthException.emailAlreadyInUse() {
    return const AuthException('Email is already in use');
  }

  factory AuthException.invalidPhoneNumber() {
    return const AuthException('Invalid phone number');
  }

  factory AuthException.invalidOTP() {
    return const AuthException('Invalid OTP code');
  }
}

/// Validation-related exceptions
class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);

  factory ValidationException.invalidEmail() {
    return const ValidationException('Invalid email format');
  }

  factory ValidationException.invalidPhoneNumber() {
    return const ValidationException('Invalid phone number format');
  }

  factory ValidationException.requiredField(String fieldName) {
    return ValidationException('$fieldName is required');
  }

  factory ValidationException.minLength(String fieldName, int minLength) {
    return ValidationException('$fieldName must be at least $minLength characters');
  }

  factory ValidationException.maxLength(String fieldName, int maxLength) {
    return ValidationException('$fieldName must be at most $maxLength characters');
  }
}

/// Storage-related exceptions
class StorageException extends AppException {
  const StorageException(super.message, [super.code]);

  factory StorageException.readError() {
    return const StorageException('Failed to read data');
  }

  factory StorageException.writeError() {
    return const StorageException('Failed to write data');
  }

  factory StorageException.deleteError() {
    return const StorageException('Failed to delete data');
  }
}

/// Payment-related exceptions
class PaymentException extends AppException {
  const PaymentException(super.message, [super.code]);

  factory PaymentException.invalidAmount() {
    return const PaymentException('Invalid payment amount');
  }

  factory PaymentException.paymentFailed() {
    return const PaymentException('Payment failed');
  }

  factory PaymentException.insufficientFunds() {
    return const PaymentException('Insufficient funds');
  }

  factory PaymentException.invalidPaymentMethod() {
    return const PaymentException('Invalid payment method');
  }
}

/// Location-related exceptions
class LocationException extends AppException {
  const LocationException(super.message, [super.code]);

  factory LocationException.permissionDenied() {
    return const LocationException('Location permission denied');
  }

  factory LocationException.locationDisabled() {
    return const LocationException('Location services are disabled');
  }

  factory LocationException.locationUnavailable() {
    return const LocationException('Location is unavailable');
  }
}

/// Unknown exception
class UnknownException extends AppException {
  const UnknownException(super.message, [super.code]);

  factory UnknownException.fromError(dynamic error) {
    return UnknownException(error.toString());
  }
}
