import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/config/app_routes.dart';
import 'package:phone_finder/data/login/login_api.dart';
import 'package:phone_finder/data/login/login_repository_impl.dart';
import 'package:phone_finder/data/login/login_storage.dart';
import 'package:phone_finder/domain/router/router_usecase.dart';
import 'package:phone_finder/domain/login/login_usecase.dart';
import 'package:phone_finder/domain/login/logout_usecase.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
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
        BlocProvider.value(value: routerCubit),
        BlocProvider(create: (_) => LoginCubit(loginUseCase)),
        BlocProvider(create: (_) => LogoutCubit(logoutUseCase)),
      ],
      child: MyApp(routerCubit: routerCubit),
    ),
  );
}

class MyApp extends StatelessWidget {
  final RouterCubit routerCubit;

  const MyApp({super.key, required this.routerCubit});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRoutes.getRouter(routerCubit),
      title: 'Phone Finder',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
    );
  }
}
