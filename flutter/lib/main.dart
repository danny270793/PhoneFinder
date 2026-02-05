import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/data/auth/auth_api.dart';
import 'package:phone_finder/data/auth/auth_repository_impl.dart';
import 'package:phone_finder/domain/auth/login_usecase.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/ui/login/login_page.dart';

void main() {
  final api = AuthApi();
  final repo = AuthRepositoryImpl(api);
  final loginUseCase = LoginUseCase(repo);
  
  runApp(
    BlocProvider(
      create: (_) => LoginCubit(loginUseCase),
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
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: LoginPage(),
    );
  }
}

