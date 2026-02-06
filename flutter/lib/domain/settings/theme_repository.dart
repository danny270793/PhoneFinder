import 'package:flutter/material.dart';

abstract class ThemeRepository {
  Future<void> saveThemeMode({required ThemeMode mode});

  Future<ThemeMode?> getThemeMode();

  Future<void> clearThemeMode();
}
