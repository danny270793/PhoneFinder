import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/l10n/app_localizations.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/login_state.dart';
import 'package:phone_finder/state/router/router_cubit.dart';

class LoginPage extends StatelessWidget {
  static const routeName = '/login';

  LoginPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.login)),
      body: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is LoginSuccess) {
            context.read<RouterCubit>().onLoginSuccess();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: l10n.email,
                    hintText: l10n.emailHint,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.password,
                    hintText: l10n.passwordHint,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: state is LoginRequested
                      ? null
                      : () {
                          context.read<LoginCubit>().login(
                            email: emailController.text,
                            password: passwordController.text,
                          );
                        },
                  child: state is LoginRequested
                      ? const CircularProgressIndicator()
                      : Text(l10n.login),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
