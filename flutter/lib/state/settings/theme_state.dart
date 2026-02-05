import 'package:flutter/material.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeInitial extends ThemeState {
  const ThemeInitial();
}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  const ThemeLoaded(this.themeMode);
}

class ThemeChanged extends ThemeState {
  final ThemeMode themeMode;

  const ThemeChanged(this.themeMode);
}
