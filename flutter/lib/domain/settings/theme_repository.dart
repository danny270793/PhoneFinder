import 'package:flutter/material.dart';

/// Repository interface for theme storage operations
abstract class ThemeRepository {
  /// Save the selected theme mode
  Future<void> saveThemeMode(ThemeMode mode);

  /// Get the saved theme mode, returns null if not set
  ThemeMode? getThemeMode();

  /// Clear the saved theme mode
  Future<void> clearThemeMode();
}
