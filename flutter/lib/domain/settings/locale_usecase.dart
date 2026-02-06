import 'package:flutter/material.dart';
import 'package:phone_finder/domain/settings/locale_repository.dart';

class LocaleUseCase {
  final LocaleRepository _repository;

  LocaleUseCase(this._repository);

  Future<void> saveLocale({required String languageCode}) async {
    await _repository.saveLocale(languageCode: languageCode);
  }

  Future<String?> getLocale() async {
    return await _repository.getLocale();
  }

  Future<void> clearLocale() async {
    await _repository.clearLocale();
  }

  Future<Locale> getLocaleOrDefault() async {
    final savedLocale = await _repository.getLocale();
    if (savedLocale != null) {
      return Locale(savedLocale);
    }
    final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    return deviceLocale;
  }
}
