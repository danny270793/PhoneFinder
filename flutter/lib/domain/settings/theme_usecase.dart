import 'package:flutter/material.dart';
import 'package:phone_finder/domain/settings/theme_repository.dart';

class ThemeUseCase {
  final ThemeRepository _repository;

  ThemeUseCase(this._repository);

  Future<void> saveThemeMode({required ThemeMode mode}) async {
    await _repository.saveThemeMode(mode: mode);
  }

  Future<ThemeMode?> getThemeMode() async {
    return await _repository.getThemeMode();
  }

  Future<void> clearThemeMode() async {
    await _repository.clearThemeMode();
  }

  Future<ThemeMode> getThemeModeOrDefault() async {
    final savedTheme = await _repository.getThemeMode();
    if (savedTheme != null) {
      return savedTheme;
    }
    return ThemeMode.system;
  }
}
