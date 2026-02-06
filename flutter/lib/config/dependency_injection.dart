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
  final prefs = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(prefs);

  getIt.registerLazySingleton<PreferencesRepository>(
    () => SharedPreferencesImpl(getIt<SharedPreferences>()),
  );

  getIt.registerLazySingleton<AuthApi>(() => AuthApi());

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

  await getIt<RouterCubit>().init();
  await getIt<LocaleCubit>().loadLocale();
  await getIt<ThemeCubit>().loadThemeMode();
}
