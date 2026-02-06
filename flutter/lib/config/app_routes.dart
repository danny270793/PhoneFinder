import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/state/router/router_state.dart';
import 'package:phone_finder/ui/pages/error_page.dart';
import 'package:phone_finder/ui/pages/home_page.dart';
import 'package:phone_finder/ui/pages/login_page.dart';
import 'package:phone_finder/ui/pages/settings_page.dart';
import 'package:phone_finder/ui/pages/splash_page.dart';

class AppRoutes {
  static const List<String> protectedRoutes = [
    HomePage.routeName,
    SettingsPage.routeName,
  ];

  static const List<String> publicRoutes = [LoginPage.routeName];

  static bool isProtected(String route) => protectedRoutes.contains(route);

  static bool isPublic(String route) => publicRoutes.contains(route);

  static GoRouterRefreshStream createRefreshStream(
    Stream<RouterState> stream,
  ) => GoRouterRefreshStream(stream);

  static String? onRedirect(RouterState routerState, String location) {
    if (routerState is RouterCheckAuthError) {
      return location == ErrorPage.routeName ? null : ErrorPage.routeName;
    }

    if (routerState is! RouterCheckAuthSuccess) {
      return location == SplashPage.routeName ? null : SplashPage.routeName;
    }

    final isLoggedIn = routerState.isLogged;

    if (location == SplashPage.routeName) {
      return isLoggedIn ? HomePage.routeName : LoginPage.routeName;
    }

    if (AppRoutes.isProtected(location) && !isLoggedIn) {
      return LoginPage.routeName;
    }

    if (AppRoutes.isPublic(location) && isLoggedIn) {
      return HomePage.routeName;
    }

    return null;
  }

  static List<GoRoute> getRoutes() => [
    GoRoute(
      path: SplashPage.routeName,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: LoginPage.routeName,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: SettingsPage.routeName,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: ErrorPage.routeName,
      builder: (context, state) => const ErrorPage(),
    ),
  ];

  static GoRouter getRouter(RouterCubit routerCubit) => GoRouter(
    initialLocation: SplashPage.routeName,
    refreshListenable: AppRoutes.createRefreshStream(routerCubit.stream),
    redirect: (BuildContext context, GoRouterState state) =>
        AppRoutes.onRedirect(
          context.read<RouterCubit>().state,
          state.matchedLocation,
        ),
    routes: AppRoutes.getRoutes(),
    observers: [RouterNavigationObserver()],
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription<RouterState> _subscription;

  GoRouterRefreshStream(Stream<RouterState> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class RouterNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    print('didPush: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    print('didPop: ${route.settings.name}');
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    print('didRemove: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    print('didReplace: ${newRoute?.settings.name}');
  }

  // @override
  // void didChangeTop(Route route, Route? previousRoute) {
  //   super.didChangeTop(route, previousRoute);
  //   print('didChangeTop: ${route.settings.name}');
  // }

  // @override
  // void didStartUserGesture(Route route, Route? previousRoute) {
  //   super.didStartUserGesture(route, previousRoute);
  //   print('didStartUserGesture: ${route.settings.name}');
  // }

  // @override
  // void didStopUserGesture() {
  //   super.didStopUserGesture();
  //   print('didStopUserGesture');
  // }
}
