import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/config/app_routes.dart';
import 'package:phone_finder/data/login/login_api.dart';
import 'package:phone_finder/data/login/login_repository_impl.dart';
import 'package:phone_finder/data/login/login_storage.dart';
import 'package:phone_finder/data/settings/locale_storage.dart';
import 'package:phone_finder/data/settings/theme_storage.dart';
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

// Conditional import: uses web implementation on web, stub on other platforms
import 'config/url_strategy_web.dart'
    if (dart.library.io) 'config/url_strategy_stub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Enable clean URLs on web (removes the # from URLs)
  usePathUrlStrategy();

  final prefs = await SharedPreferences.getInstance();
  final storage = LoginStorage(prefs);
  final localeStorage = LocaleStorage(prefs);
  final themeStorage = ThemeStorage(prefs);
  final api = AuthApi();
  final repo = LoginRepositoryImpl(api, storage);
  final loginUseCase = LoginUseCase(repo);
  final logoutUseCase = LogoutUseCase(repo);
  final routerUseCase = RouterUseCase(repo);

  final routerCubit = RouterCubit(routerUseCase);
  final localeCubit = LocaleCubit(localeStorage);
  final themeCubit = ThemeCubit(themeStorage);
  
  // Load saved locale and theme
  await localeCubit.loadLocale();
  await themeCubit.loadThemeMode();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: routerCubit),
        BlocProvider.value(value: localeCubit),
        BlocProvider.value(value: themeCubit),
        BlocProvider(create: (_) => LoginCubit(loginUseCase)),
        BlocProvider(create: (_) => LogoutCubit(logoutUseCase)),
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
    // Create router once and reuse it
    _router = AppRoutes.getRouter(widget.routerCubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        // Get the current locale from cubit
        final locale = context.read<LocaleCubit>().currentLocale;

        return BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            // Get the current theme mode from cubit
            final themeMode = context.read<ThemeCubit>().currentThemeMode;

            return MaterialApp.router(
              routerConfig: _router, // Use the same router instance
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
