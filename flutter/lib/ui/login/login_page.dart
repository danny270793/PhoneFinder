import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/login_state.dart';
import 'package:phone_finder/ui/login/home_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is LoginSuccess) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: emailController),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: state is LoginRequested
                      ? null
                      : () {
                          context.read<LoginCubit>().login(
                                emailController.text,
                                passwordController.text,
                              );
                        },
                  child: state is LoginRequested
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
