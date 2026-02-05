import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/settings/locale_repository.dart';
import 'package:phone_finder/state/settings/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleRepository _repository;

  LocaleCubit(this._repository) : super(const LocaleInitial()) {}

  Future<void> loadLocale() async {
    final savedLocale = _repository.getLocale();
    if (savedLocale != null) {
      emit(LocaleLoaded(Locale(savedLocale)));
    } else {
      emit(const LocaleLoaded(Locale('en')));
    }
  }

  Future<void> changeLocale(String languageCode) async {
    await _repository.saveLocale(languageCode);
    emit(LocaleChanged(Locale(languageCode)));
  }

  Locale get currentLocale {
    final currentState = state;
    if (currentState is LocaleLoaded) {
      return currentState.locale;
    } else if (currentState is LocaleChanged) {
      return currentState.locale;
    }
    return const Locale('en');
  }
}
