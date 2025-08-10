import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../result/result.dart';

/// Base class for all controllers in the app
abstract class BaseController extends StateNotifier<AsyncValue<void>> {
  BaseController() : super(const AsyncValue.data(null));

  /// List of disposables to be disposed when the controller is disposed
  final List<dynamic> _disposables = <dynamic>[];

  /// Adds a disposable to the list
  void addDisposable(dynamic disposable) {
    _disposables.add(disposable);
  }

  /// Handles errors and updates the state accordingly
  void handleError(Object error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('Error in ${runtimeType}: $error');
      if (stackTrace != null) {
        print('StackTrace: $stackTrace');
      }
    }
    
    state = AsyncValue.error(error, stackTrace ?? StackTrace.current);
  }

  /// Handles a Result and updates the state accordingly
  void handleResult<T>(Result<T> result) {
    result.when(
      success: (_) {
        state = const AsyncValue.data(null);
      },
      failure: (exception) {
        handleError(exception);
      },
    );
  }

  /// Executes an async operation and handles errors automatically
  Future<void> execute(Future<void> Function() operation) async {
    try {
      state = const AsyncValue.loading();
      await operation();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  /// Executes an async operation that returns a Result
  Future<void> executeWithResult<T>(Future<Result<T>> Function() operation) async {
    try {
      state = const AsyncValue.loading();
      final result = await operation();
      handleResult(result);
    } catch (error, stackTrace) {
      handleError(error, stackTrace);
    }
  }

  /// Clears the current error state
  void clearError() {
    state = const AsyncValue.data(null);
  }

  /// Returns true if the controller is currently loading
  bool get isLoading => state.isLoading;

  /// Returns true if the controller has an error
  bool get hasError => state.hasError;

  /// Returns the current error if any
  Object? get error => state.error;

  @override
  void dispose() {
    // Dispose all disposables
    for (final disposable in _disposables) {
      if (disposable is ChangeNotifier) {
        disposable.dispose();
      } else if (disposable is StreamSubscription) {
        disposable.cancel();
      } else if (disposable is Timer) {
        disposable.cancel();
      }
    }
    _disposables.clear();
    
    super.dispose();
  }
}

/// Mixin for controllers that need to handle loading states
mixin LoadingMixin on BaseController {
  /// Sets the loading state
  void setLoading(bool loading) {
    if (loading) {
      state = const AsyncValue.loading();
    } else {
      state = const AsyncValue.data(null);
    }
  }
}

/// Mixin for controllers that need to handle data states
mixin DataMixin<T> on BaseController {
  /// The current data state
  AsyncValue<T> get dataState => state.map(
    data: (data) => AsyncValue.data(data.value as T),
    loading: (loading) => AsyncValue.loading(),
    error: (error) => AsyncValue.error(error.error, error.stackTrace),
  );

  /// Sets the data state
  void setData(T data) {
    state = AsyncValue.data(data);
  }

  /// Returns the current data value
  T? get data => dataState.value;
}
