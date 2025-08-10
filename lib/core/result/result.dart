import 'package:equatable/equatable.dart';

/// A type that represents either a success or failure result
sealed class Result<T> extends Equatable {
  const Result();

  /// Returns true if this is a success result
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a failure result
  bool get isFailure => this is Failure<T>;

  /// Returns the success value if this is a success result, null otherwise
  T? get successValue => isSuccess ? (this as Success<T>).value : null;

  /// Returns the failure value if this is a failure result, null otherwise
  Exception? get failureValue => isFailure ? (this as Failure<T>).exception : null;

  /// Maps the success value to a new type
  Result<R> map<R>(R Function(T value) mapper) {
    return when(
      success: (value) => Success(mapper(value)),
      failure: (exception) => Failure(exception),
    );
  }

  /// Maps the failure value to a new type
  Result<T> mapFailure(Exception Function(Exception exception) mapper) {
    return when(
      success: (value) => Success(value),
      failure: (exception) => Failure(mapper(exception)),
    );
  }

  /// Executes a function based on whether this is a success or failure
  R when<R>({
    required R Function(T value) success,
    required R Function(Exception exception) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    } else if (this is Failure<T>) {
      return failure((this as Failure<T>).exception);
    }
    throw StateError('Result is neither Success nor Failure');
  }

  /// Executes a function only if this is a success result
  void whenSuccess(void Function(T value) callback) {
    if (isSuccess) {
      callback(successValue!);
    }
  }

  /// Executes a function only if this is a failure result
  void whenFailure(void Function(Exception exception) callback) {
    if (isFailure) {
      callback(failureValue!);
    }
  }
}

/// A success result containing a value
class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;

  @override
  List<Object?> get props => [value];

  @override
  String toString() => 'Success($value)';
}

/// A failure result containing an exception
class Failure<T> extends Result<T> {
  const Failure(this.exception);

  final Exception exception;

  @override
  List<Object?> get props => [exception];

  @override
  String toString() => 'Failure($exception)';
}

/// Extension methods for Result
extension ResultExtensions<T> on Result<T> {
  /// Returns the success value or throws the exception if this is a failure
  T getOrThrow() {
    return when(
      success: (value) => value,
      failure: (exception) => throw exception,
    );
  }

  /// Returns the success value or a default value if this is a failure
  T getOrElse(T defaultValue) {
    return when(
      success: (value) => value,
      failure: (_) => defaultValue,
    );
  }

  /// Returns the success value or null if this is a failure
  T? getOrNull() {
    return when(
      success: (value) => value,
      failure: (_) => null,
    );
  }
}
