import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/domain/settings/locale_usecase.dart';
import 'package:phone_finder/state/settings/locale_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  final LocaleUseCase _useCase;

  LocaleCubit(this._useCase) : super(const LocaleInitial()) {}

  Future<void> loadLocale() async {
    final locale = await _useCase.getLocaleOrDefault();
    emit(LocaleLoaded(locale));
  }

  Future<void> changeLocale({required String languageCode}) async {
    await _useCase.saveLocale(languageCode: languageCode);
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
