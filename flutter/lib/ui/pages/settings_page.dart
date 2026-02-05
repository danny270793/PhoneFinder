import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/l10n/app_localizations.dart';
import 'package:phone_finder/state/settings/locale_cubit.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.read<LocaleCubit>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Section
          Text(
            l10n.language,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(l10n.languageEnglish),
                  subtitle: const Text('English'),
                  value: 'en',
                  groupValue: localeCubit.currentLocale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      localeCubit.changeLocale(value);
                    }
                  },
                ),
                const Divider(height: 1),
                RadioListTile<String>(
                  title: Text(l10n.languageSpanish),
                  subtitle: const Text('Español'),
                  value: 'es',
                  groupValue: localeCubit.currentLocale.languageCode,
                  onChanged: (value) {
                    if (value != null) {
                      localeCubit.changeLocale(value);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
