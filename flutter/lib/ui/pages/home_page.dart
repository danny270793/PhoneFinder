import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:phone_finder/l10n/app_localizations.dart';
import 'package:phone_finder/state/login/logout_cubit.dart';
import 'package:phone_finder/state/login/logout_state.dart';
import 'package:phone_finder/state/router/router_cubit.dart';
import 'package:phone_finder/ui/pages/settings_page.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.home),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: l10n.settings,
            onPressed: () {
              context.push(SettingsPage.routeName);
            },
          ),
        ],
      ),
      body: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is LogoutSuccess) {
            context.read<RouterCubit>().onLogoutSuccess();
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: state is LogoutRequested
                      ? null
                      : () {
                          context.read<LogoutCubit>().logout();
                        },
                  child: state is LogoutRequested
                      ? const CircularProgressIndicator()
                      : Text(l10n.logout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
