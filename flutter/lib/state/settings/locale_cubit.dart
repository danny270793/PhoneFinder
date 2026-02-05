import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/data/settings/locale_storage.dart';
import 'package:phone_finder/state/settings/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleStorage _storage;

  LocaleCubit(this._storage) : super(const LocaleInitial()) {
    loadLocale();
  }

  /// Load the saved locale from storage
  Future<void> loadLocale() async {
    final savedLocale = _storage.getLocale();
    if (savedLocale != null) {
      emit(LocaleLoaded(Locale(savedLocale)));
    } else {
      // Default to English if no locale is saved
      emit(const LocaleLoaded(Locale('en')));
    }
  }

  /// Change the locale and save it
  Future<void> changeLocale(String languageCode) async {
    await _storage.saveLocale(languageCode);
    emit(LocaleChanged(Locale(languageCode)));
  }

  /// Get the current locale
  Locale get currentLocale {
    final currentState = state;
    if (currentState is LocaleLoaded) {
      return currentState.locale;
    } else if (currentState is LocaleChanged) {
      return currentState.locale;
    }
    return const Locale('en'); // Default fallback
  }
}
