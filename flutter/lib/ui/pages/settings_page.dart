import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phone_finder/l10n/app_localizations.dart';
import 'package:phone_finder/state/settings/locale_cubit.dart';
import 'package:phone_finder/state/settings/locale_state.dart';
import 'package:phone_finder/state/settings/theme_cubit.dart';
import 'package:phone_finder/state/settings/theme_state.dart';

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

  String _getThemeModeName(ThemeMode themeMode, AppLocalizations l10n) {
    switch (themeMode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }

  IconData _getThemeModeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
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

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeCubit = context.read<ThemeCubit>();
    final currentTheme = themeCubit.currentThemeMode;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.theme),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeLight),
              secondary: const Icon(Icons.light_mode),
              value: ThemeMode.light,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  themeCubit.changeThemeMode(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeDark),
              secondary: const Icon(Icons.dark_mode),
              value: ThemeMode.dark,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  themeCubit.changeThemeMode(value);
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.themeSystem),
              secondary: const Icon(Icons.brightness_auto),
              value: ThemeMode.system,
              groupValue: currentTheme,
              onChanged: (value) {
                if (value != null) {
                  themeCubit.changeThemeMode(value);
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
        builder: (context, localeState) {
          final currentLanguageCode =
              context.read<LocaleCubit>().currentLocale.languageCode;
          final currentLanguageName = _getLanguageName(currentLanguageCode, l10n);
          final currentLanguageNative = _getLanguageNativeName(currentLanguageCode);

          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final currentThemeMode = context.read<ThemeCubit>().currentThemeMode;
              final currentThemeName = _getThemeModeName(currentThemeMode, l10n);
              final currentThemeIcon = _getThemeModeIcon(currentThemeMode);

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
                  const Divider(),
                  ListTile(
                    leading: Icon(currentThemeIcon),
                    title: Text(l10n.theme),
                    subtitle: Text(currentThemeName),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showThemeDialog(context),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
