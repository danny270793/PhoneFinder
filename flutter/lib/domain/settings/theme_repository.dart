import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<void> saveThemeMode({required ThemeMode mode});

  ThemeMode? getThemeMode();

  Future<void> clearThemeMode();
}
