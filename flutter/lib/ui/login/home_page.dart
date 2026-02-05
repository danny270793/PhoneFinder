import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/state/login/login_cubit.dart';
import 'package:phone_finder/state/login/login_state.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/state/login/logout_state.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
                children: [
                  ElevatedButton(
                  onPressed: state is LogoutIdle
                      ? null
                      : () {
                          // context.read<LogoutCubit>().logout(user);
                        },
                  child: state is LogoutRequested
                      ? const CircularProgressIndicator()
                      : const Text('Logout'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
