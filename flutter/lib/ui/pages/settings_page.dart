import 'package:flutter/material.dart';
import 'package:phone_finder/l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = '/settings';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: const Center(
        child: Text('Settings coming soon...'),
      ),
    );
  }
}
