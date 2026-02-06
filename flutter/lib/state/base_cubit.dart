import 'package:flutter_bloc/flutter_bloc.dart';

/// Base cubit with automatic error handling
/// All cubits should extend this to get consistent error handling
abstract class BaseCubit<State> extends Cubit<State> {
  BaseCubit(super.initialState);

  /// Safe execute wrapper that catches errors and reports them
  Future<void> safeExecute(
    Future<void> Function() action, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      await action();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      onError?.call(error, stackTrace);
    }
  }

  /// Safe execute with return value
  Future<T?> safeExecuteWithResult<T>(
    Future<T> Function() action, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return await action();
    } catch (error, stackTrace) {
      addError(error, stackTrace);
      onError?.call(error, stackTrace);
      return null;
    }
  }
}
