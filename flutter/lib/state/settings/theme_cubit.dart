import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/settings/theme_repository.dart';
import 'package:phone_finder/state/settings/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeRepository _repository;

  ThemeCubit(this._repository) : super(const ThemeInitial());

  Future<void> loadThemeMode() async {
    final savedThemeMode = _repository.getThemeMode();
    if (savedThemeMode != null) {
      emit(ThemeLoaded(savedThemeMode));
    } else {
      emit(const ThemeLoaded(ThemeMode.system));
    }
  }

  Future<void> changeThemeMode(ThemeMode mode) async {
    await _repository.saveThemeMode(mode);
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
