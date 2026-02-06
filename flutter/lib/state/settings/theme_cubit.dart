import 'package:flutter/material.dart';
import 'package:phone_finder/domain/settings/theme_usecase.dart';
import 'package:phone_finder/state/base_cubit.dart';
import 'package:phone_finder/state/settings/theme_state.dart';

class ThemeCubit extends BaseCubit<ThemeState> {
  final ThemeUseCase _useCase;

  ThemeCubit(this._useCase) : super(const ThemeInitial());

  @override
  ThemeState createErrorState(String message) => ThemeError(message);

  Future<void> loadThemeMode() async {
    await safeExecute(() async {
      final themeMode = _useCase.getThemeModeOrDefault();
      emit(ThemeLoaded(themeMode));
    });
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    await safeExecute(() async {
      await _useCase.saveThemeMode(mode);
      emit(ThemeChanged(mode));
    });
  }

  ThemeMode get currentThemeMode {
    final currentState = state;
    if (currentState is ThemeLoaded) {
      return currentState.themeMode;
    } else if (currentState is ThemeChanged) {
      return currentState.themeMode;
    }
    return ThemeMode.system;
  }
}
