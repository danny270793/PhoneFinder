import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/data/auth/auth_api.dart';
import 'package:phone_finder/data/auth/auth_repository_impl.dart';
import 'package:phone_finder/data/auth/user_storage.dart';
import 'package:phone_finder/domain/auth/login_usecase.dart';
import 'package:phone_finder/domain/auth/logout_usecase.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/ui/login/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final storage = UserStorage(prefs);
  final api = AuthApi();
  final repo = AuthRepositoryImpl(api, storage);
  final loginUseCase = LoginUseCase(repo);
  final logoutUseCase = LogoutUseCase(repo);
  
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit(loginUseCase)),
        BlocProvider(create: (_) => LogoutCubit(logoutUseCase)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
    );
  }
}

