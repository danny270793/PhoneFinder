import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/settings/theme_usecase.dart';
import 'package:phone_finder/state/settings/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeUseCase _useCase;

  ThemeCubit(this._useCase) : super(ThemeIdle());

  Future<void> loadThemeMode() async {
    final themeMode = await _useCase.getThemeModeOrDefault();
    emit(ThemeLoaded(themeMode: themeMode));
  }

  Future<void> changeThemeMode({required ThemeMode mode}) async {
    await _useCase.saveThemeMode(mode: mode);
    emit(ThemeChanged(themeMode: mode));
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
