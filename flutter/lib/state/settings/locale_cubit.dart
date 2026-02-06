import 'package:flutter/material.dart';
import 'package:phone_finder/domain/settings/locale_usecase.dart';
import 'package:phone_finder/state/base_cubit.dart';
import 'package:phone_finder/state/settings/locale_state.dart';

class LocaleCubit extends BaseCubit<LocaleState> {
  final LocaleUseCase _useCase;

  LocaleCubit(this._useCase) : super(const LocaleInitial()) {}

  @override
  LocaleState createErrorState(String message) => LocaleError(message);

  Future<void> loadLocale() async {
    await safeExecute(() async {
      final locale = _useCase.getLocaleOrDefault();
      emit(LocaleLoaded(locale));
    });
  }

  Future<void> changeLocale(String languageCode) async {
    await safeExecute(() async {
      await _useCase.saveLocale(languageCode);
      emit(LocaleChanged(Locale(languageCode)));
    });
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
