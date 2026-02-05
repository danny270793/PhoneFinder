import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/config/app_routes.dart';
import 'package:phone_finder/data/login/login_api.dart';
import 'package:phone_finder/data/login/login_repository.dart';
import 'package:phone_finder/data/login/login_repository_impl.dart';
import 'package:phone_finder/data/settings/locale_storage.dart';
import 'package:phone_finder/data/settings/theme_storage.dart';
import 'package:phone_finder/data/storage/shared_preferences_impl.dart';
import 'package:phone_finder/domain/settings/locale_repository.dart';
import 'package:phone_finder/domain/settings/theme_repository.dart';
import 'package:phone_finder/domain/settings/locale_usecase.dart';
import 'package:phone_finder/domain/settings/theme_usecase.dart';
import 'package:phone_finder/domain/storage/preferences_repository.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/domain/login/logout_usecase.dart';
import 'package:phone_finder/l10n/app_localizations.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/state/settings/locale_cubit.dart';
import 'package:phone_finder/state/settings/locale_state.dart';
import 'package:phone_finder/state/settings/theme_cubit.dart';
import 'package:phone_finder/state/settings/theme_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/url_strategy_web.dart'
    if (dart.library.io) 'config/url_strategy_stub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  final prefs = await SharedPreferences.getInstance();
  final PreferencesRepository preferencesRepository = SharedPreferencesImpl(prefs);
  
  final api = AuthApi();
  
  final LocaleRepository localeRepository = LocaleStorageImpl(preferencesRepository);
  final ThemeRepository themeRepository = ThemeStorageImpl(preferencesRepository);
  final LoginRepository loginRepository = LoginRepositoryImpl(api, preferencesRepository);
  
  final loginUseCase = LoginUseCase(loginRepository);
  final logoutUseCase = LogoutUseCase(loginRepository);
  final routerUseCase = RouterUseCase(loginRepository);
  final localeUseCase = LocaleUseCase(localeRepository);
  final themeUseCase = ThemeUseCase(themeRepository);
  
  final loginCubit = LoginCubit(loginUseCase);
  final logoutCubit = LogoutCubit(logoutUseCase);
  final routerCubit = RouterCubit(routerUseCase);
  final localeCubit = LocaleCubit(localeUseCase);
  final themeCubit = ThemeCubit(themeUseCase);

  await routerCubit.init();
  await localeCubit.loadLocale();
  await themeCubit.loadThemeMode();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: loginCubit),
        BlocProvider.value(value: logoutCubit),
        BlocProvider.value(value: routerCubit),
        BlocProvider.value(value: localeCubit),
        BlocProvider.value(value: themeCubit),
      ],
      child: MyApp(routerCubit: routerCubit),
    ),
  );
}

class MyApp extends StatefulWidget {
  final RouterCubit routerCubit;

  const MyApp({super.key, required this.routerCubit});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRoutes.getRouter(widget.routerCubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final locale = context.read<LocaleCubit>().currentLocale;

        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final themeMode = context.read<ThemeCubit>().currentThemeMode;

            return MaterialApp.router(
              routerConfig: _router,
              locale: locale,
              themeMode: themeMode,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateTitle: (context) =>
                  AppLocalizations.of(context)!.appTitle,
              theme: ThemeData.light(useMaterial3: true),
              darkTheme: ThemeData.dark(useMaterial3: true),
            );
          },
        );
      },
    );
  }
}
