import 'package:flutter_bloc/flutter_bloc.dart';

/// Base cubit with automatic error handling
/// All cubits should extend this to get consistent error handling
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  /// Create an error state for this cubit
  /// Each cubit must implement this to define its error state
  State createErrorState(String message);

  /// Safe execute wrapper that catches errors and reports them
  /// Automatically emits error state on failure
  Future<void> safeExecute(
    Future<void> Function() action, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      await action();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      if (onError != null) {
        onError(error, stackTrace);
      } else {
        // Automatically emit error state if no custom handler provided
        emit(createErrorState(error.toString()));
      }
    }
  }

  /// Safe execute with return value
  /// Automatically emits error state on failure
  Future<T?> safeExecuteWithResult<T>(
    Future<T> Function() action, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      if (onError != null) {
        onError(error, stackTrace);
      } else {
        // Automatically emit error state if no custom handler provided
        emit(createErrorState(error.toString()));
      }
      return null;
    }
  }
}
