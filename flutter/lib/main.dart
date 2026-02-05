import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/config/app_routes.dart';
import 'package:phone_finder/config/dependency_injection.dart';
import 'package:phone_finder/l10n/app_localizations.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/state/settings/locale_cubit.dart';
import 'package:phone_finder/state/settings/locale_state.dart';
import 'package:phone_finder/state/settings/theme_cubit.dart';
import 'package:phone_finder/state/settings/theme_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'config/url_strategy_web.dart'
    if (dart.library.io) 'config/url_strategy_stub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  await configureDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(value: getIt<LoginCubit>()),
        BlocProvider.value(value: getIt<LogoutCubit>()),
        BlocProvider.value(value: getIt<RouterCubit>()),
        BlocProvider.value(value: getIt<LocaleCubit>()),
        BlocProvider.value(value: getIt<ThemeCubit>()),
      ],
      child: MyApp(routerCubit: getIt<RouterCubit>()),
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
