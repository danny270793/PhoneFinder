import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/data/login/login_api.dart';
import 'package:phone_finder/data/login/login_repository_impl.dart';
import 'package:phone_finder/data/login/login_storage.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/domain/login/logout_usecase.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/state/router/router_state.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/ui/pages/error_page.dart';
import 'package:phone_finder/ui/pages/home_page.dart';
import 'package:phone_finder/ui/pages/login_page.dart';
import 'package:phone_finder/ui/pages/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final storage = LoginStorage(prefs);
  final api = AuthApi();
  final repo = LoginRepositoryImpl(api, storage);
  final loginUseCase = LoginUseCase(repo);
  final logoutUseCase = LogoutUseCase(repo);
  final routerUseCase = RouterUseCase(repo);

  final routerCubit = RouterCubit(routerUseCase);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(loginUseCase)),
        BlocProvider(create: (_) => LogoutCubit(logoutUseCase)),
        BlocProvider(create: (_) => routerCubit),
      ],
      child: MyApp(routerCubit: routerCubit),
    ),
  );
}

final protectedPages = const [
  HomePage.routeName,
];
final publicPages = const [
  LoginPage.routeName,
];

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshStream(Stream stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  final RouterCubit routerCubit;

  const MyApp({super.key, required this.routerCubit});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        initialLocation: SplashPage.routeName,
        refreshListenable: GoRouterRefreshStream(routerCubit.stream),
        redirect: (context, state) {
          final routerState = context.read<RouterCubit>().state;
          if(routerState is RouterInitSuccess) {
            final location = state.matchedLocation;
            final isLoggedIn = routerState.isLogged;

            if(location == SplashPage.routeName) {
              if(isLoggedIn) {
                return HomePage.routeName;
              } else {
                return LoginPage.routeName;
              }
            }

            final isPublicPage = publicPages.contains(location);
            final isProtectedPage = protectedPages.contains(location);

            if (isProtectedPage && !isLoggedIn) {
              return LoginPage.routeName;
            }

            if (isPublicPage && isLoggedIn) {
              return HomePage.routeName;
            }

            return null;
          } else if(routerState is RouterInitError) {
            return ErrorPage.routeName;
          } else {
            return SplashPage.routeName;
          }
        },
        routes: [
          GoRoute(path: SplashPage.routeName, builder: (context, state) => const SplashPage()),
          GoRoute(path: LoginPage.routeName, builder: (context, state) => LoginPage()),
          GoRoute(path: HomePage.routeName, builder: (context, state) => const HomePage()),
          GoRoute(path: ErrorPage.routeName, builder: (context, state) => const ErrorPage()),
        ],
      ),
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}

