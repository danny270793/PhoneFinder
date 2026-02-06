import 'package:flutter/material.dart';

abstract class LocaleState {
  const LocaleState();
}

class LocaleIdle extends LocaleState {}

class LocaleLoaded extends LocaleState {
  final Locale locale;

  const LocaleLoaded({required this.locale});
}

class LocaleChanged extends LocaleState {
  final Locale locale;

  const LocaleChanged({required this.locale});
}
