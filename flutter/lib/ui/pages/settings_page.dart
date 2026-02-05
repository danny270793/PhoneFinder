import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/l10n/app_localizations.dart';
import 'package:phone_finder/state/settings/locale_cubit.dart';
import 'package:phone_finder/state/settings/locale_state.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  String _getLanguageName(String languageCode, AppLocalizations l10n) {
    switch (languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'es':
        return l10n.languageSpanish;
      default:
        return languageCode;
    }
  }

  String _getLanguageNativeName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return languageCode;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeCubit = context.read<LocaleCubit>();
    final currentLanguage = localeCubit.currentLocale.languageCode;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.languageEnglish),
              subtitle: const Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  localeCubit.changeLocale(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.languageSpanish),
              subtitle: const Text('Español'),
              value: 'es',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  localeCubit.changeLocale(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          final currentLanguageCode =
              context.read<LocaleCubit>().currentLocale.languageCode;
          final currentLanguageName = _getLanguageName(currentLanguageCode, l10n);
          final currentLanguageNative = _getLanguageNativeName(currentLanguageCode);

          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                subtitle: Text(currentLanguageNative),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentLanguageName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
                onTap: () => _showLanguageDialog(context),
              ),
            ],
          );
        },
      ),
    );
  }
}
