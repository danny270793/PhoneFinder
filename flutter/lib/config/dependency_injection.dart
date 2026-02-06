import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:phone_finder/data/login/login_api.dart';
import 'package:phone_finder/data/login/login_repository.dart';
import 'package:phone_finder/data/login/login_repository_impl.dart';
import 'package:phone_finder/data/settings/locale_storage.dart';
import 'package:phone_finder/data/settings/theme_storage.dart';
import 'package:phone_finder/data/storage/shared_preferences_impl.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/domain/login/logout_usecase.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/domain/settings/locale_repository.dart';
import 'package:phone_finder/domain/settings/locale_usecase.dart';
import 'package:phone_finder/domain/settings/theme_repository.dart';
import 'package:phone_finder/domain/settings/theme_usecase.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/state/settings/locale_cubit.dart';
import 'package:phone_finder/state/settings/theme_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // External dependencies
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  // Data layer - Storage
  getIt.registerLazySingleton<PreferencesRepository>(
    () => SharedPreferencesImpl(getIt<SharedPreferences>()),
  );

  // Data layer - API
  getIt.registerLazySingleton<AuthApi>(() => AuthApi());

  // Data layer - Repositories
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(
      getIt<AuthApi>(),
      getIt<PreferencesRepository>(),
    ),
  );

  getIt.registerLazySingleton<LocaleRepository>(
    () => LocaleStorageImpl(getIt<PreferencesRepository>()),
  );

  getIt.registerLazySingleton<ThemeRepository>(
    () => ThemeStorageImpl(getIt<PreferencesRepository>()),
  );

  // Domain layer - Use cases
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<LoginRepository>()),
  );

  getIt.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(getIt<LoginRepository>()),
  );

  getIt.registerLazySingleton<RouterUseCase>(
    () => RouterUseCase(getIt<LoginRepository>()),
  );

  getIt.registerLazySingleton<LocaleUseCase>(
    () => LocaleUseCase(getIt<LocaleRepository>()),
  );

  getIt.registerLazySingleton<ThemeUseCase>(
    () => ThemeUseCase(getIt<ThemeRepository>()),
  );

  // State layer - Cubits
  getIt.registerFactory<LoginCubit>(
    () => LoginCubit(getIt<LoginUseCase>()),
  );

  getIt.registerFactory<LogoutCubit>(
    () => LogoutCubit(getIt<LogoutUseCase>()),
  );

  getIt.registerLazySingleton<RouterCubit>(
    () => RouterCubit(getIt<RouterUseCase>()),
  );

  getIt.registerLazySingleton<LocaleCubit>(
    () => LocaleCubit(getIt<LocaleUseCase>()),
  );

  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(getIt<ThemeUseCase>()),
  );

  // Initialize cubits that need it
  await getIt<RouterCubit>().init();
  await getIt<LocaleCubit>().loadLocale();
  await getIt<ThemeCubit>().loadThemeMode();
}

class AppEventsObserver extends BlocObserver {
  @override
  void onCreate(BlocBase<dynamic> bloc) {
    print('onCreate: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    print('onEvent: ${bloc.runtimeType} - $event');
  }
  
  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    print('onChange: ${bloc.runtimeType} - $change');
  }

  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    print('onTransition: ${bloc.runtimeType} - $transition');
  }
  
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print('onError: ${bloc.runtimeType} - $error');
  }

  @override
  void onDone(Bloc<dynamic, dynamic> bloc, Object? event, [Object? error, StackTrace? stackTrace]) {
    print('onDone: ${bloc.runtimeType} - $event - $error - $stackTrace');
  }
  
  @override
  void onClose(BlocBase<dynamic> bloc) {
    print('onClose: ${bloc.runtimeType}');
  }
}
