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

  String _getLanguageNativeName(String languageCode, AppLocalizations l10n) {
    switch (languageCode) {
      case 'en':
        return l10n.languageEnglishNative;
      case 'es':
        return l10n.languageSpanishNative;
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
    String selectedLanguage = localeCubit.currentLocale.languageCode;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.languageEnglish),
                subtitle: Text(l10n.languageEnglishNative),
                leading: Icon(
                  selectedLanguage == 'en' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                selected: selectedLanguage == 'en',
                onTap: () {
                  setState(() {
                    selectedLanguage = 'en';
                  });
                  localeCubit.changeLocale(languageCode: 'en');
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                title: Text(l10n.languageSpanish),
                subtitle: Text(l10n.languageSpanishNative),
                leading: Icon(
                  selectedLanguage == 'es' ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                selected: selectedLanguage == 'es',
                onTap: () {
                  setState(() {
                    selectedLanguage = 'es';
                  });
                  localeCubit.changeLocale(languageCode: 'es');
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final themeCubit = context.read<ThemeCubit>();
    ThemeMode selectedTheme = themeCubit.currentThemeMode;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.theme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.themeLight),
                leading: Icon(
                  selectedTheme == ThemeMode.light ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                trailing: const Icon(Icons.light_mode),
                selected: selectedTheme == ThemeMode.light,
                onTap: () {
                  setState(() {
                    selectedTheme = ThemeMode.light;
                  });
                  themeCubit.changeThemeMode(mode: ThemeMode.light);
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                title: Text(l10n.themeDark),
                leading: Icon(
                  selectedTheme == ThemeMode.dark ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                trailing: const Icon(Icons.dark_mode),
                selected: selectedTheme == ThemeMode.dark,
                onTap: () {
                  setState(() {
                    selectedTheme = ThemeMode.dark;
                  });
                  themeCubit.changeThemeMode(mode: ThemeMode.dark);
                  Navigator.of(dialogContext).pop();
                },
              ),
              ListTile(
                title: Text(l10n.themeSystem),
                leading: Icon(
                  selectedTheme == ThemeMode.system ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                ),
                trailing: const Icon(Icons.brightness_auto),
                selected: selectedTheme == ThemeMode.system,
                onTap: () {
                  setState(() {
                    selectedTheme = ThemeMode.system;
                  });
                  themeCubit.changeThemeMode(mode: ThemeMode.system);
                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          ),
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
          final currentLanguageCode = context
              .read<LocaleCubit>()
              .currentLocale
              .languageCode;
          final currentLanguageNative = _getLanguageNativeName(
            currentLanguageCode,
            l10n,
          );

          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              final currentThemeMode = context
                  .read<ThemeCubit>()
                  .currentThemeMode;
              final currentThemeName = _getThemeModeName(
                currentThemeMode,
                l10n,
              );
              final currentThemeIcon = _getThemeModeIcon(currentThemeMode);

              return ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(l10n.language),
                    subtitle: Text(currentLanguageNative),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
