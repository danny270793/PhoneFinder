import 'package:flutter/material.dart';

abstract class ThemeState {
  const ThemeState();
}

class ThemeIdle extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  const ThemeLoaded({required this.themeMode});
}

class ThemeChanged extends ThemeState {
  final ThemeMode themeMode;

  const ThemeChanged({required this.themeMode});
}
