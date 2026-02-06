import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/settings/theme_usecase.dart';
import 'package:phone_finder/state/settings/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeUseCase _useCase;

  ThemeCubit(this._useCase) : super(const ThemeInitial());

  Future<void> loadThemeMode() async {
    final themeMode = _useCase.getThemeModeOrDefault();
    emit(ThemeLoaded(themeMode));
  }

  Future<void> changeThemeMode({required ThemeMode mode}) async {
    await _useCase.saveThemeMode(mode: mode);
    emit(ThemeChanged(mode));
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
