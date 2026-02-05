import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/data/settings/theme_storage.dart';
import 'package:phone_finder/state/settings/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final ThemeStorage _storage;

  ThemeCubit(this._storage) : super(const ThemeInitial());

  /// Load the saved theme mode from storage
  Future<void> loadThemeMode() async {
    final savedThemeMode = _storage.getThemeMode();
    if (savedThemeMode != null) {
      emit(ThemeLoaded(savedThemeMode));
    } else {
      // Default to system theme if no theme is saved
      emit(const ThemeLoaded(ThemeMode.system));
    }
  }

  /// Change the theme mode and save it
  Future<void> changeThemeMode(ThemeMode mode) async {
    await _storage.saveThemeMode(mode);
    emit(ThemeChanged(mode));
  }

  /// Get the current theme mode
  ThemeMode get currentThemeMode {
    final currentState = state;
    if (currentState is ThemeLoaded) {
      return currentState.themeMode;
    } else if (currentState is ThemeChanged) {
      return currentState.themeMode;
    }
    return ThemeMode.system; // Default fallback
  }
}
