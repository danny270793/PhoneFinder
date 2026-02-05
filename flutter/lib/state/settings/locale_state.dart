import 'package:flutter/material.dart';

/// Base class for locale state
abstract class LocaleState {
  const LocaleState();
}

/// Initial state
class LocaleInitial extends LocaleState {
  const LocaleInitial();
}

/// Locale loaded from storage
class LocaleLoaded extends LocaleState {
  final Locale locale;

  const LocaleLoaded(this.locale);
}

/// Locale changed by user
class LocaleChanged extends LocaleState {
  final Locale locale;

  const LocaleChanged(this.locale);
}
