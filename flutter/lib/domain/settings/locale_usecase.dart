import 'package:flutter/material.dart';
import 'package:phone_finder/domain/settings/locale_repository.dart';

class LocaleUseCase {
  final LocaleRepository _repository;

  LocaleUseCase(this._repository);

  Future<void> saveLocale(String languageCode) async {
    await _repository.saveLocale(languageCode);
  }

  String? getLocale() {
    return _repository.getLocale();
  }

  Future<void> clearLocale() async {
    await _repository.clearLocale();
  }

  Locale getLocaleOrDefault() {
    final savedLocale = _repository.getLocale();
    if (savedLocale != null) {
      return Locale(savedLocale);
    }
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return deviceLocale;
  }
}
