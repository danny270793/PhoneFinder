import 'package:flutter/material.dart';

/// Base class for theme state
abstract class ThemeState {
  const ThemeState();
}

/// Initial state
class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

/// Theme loaded from storage
class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  const ThemeLoaded(this.themeMode);
}

/// Theme changed by user
class ThemeChanged extends ThemeState {
  final ThemeMode themeMode;

  const ThemeChanged(this.themeMode);
}
