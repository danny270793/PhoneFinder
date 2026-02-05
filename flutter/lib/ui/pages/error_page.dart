import 'package:flutter/material.dart';
import 'package:phone_finder/l10n/app_localizations.dart';

class ErrorPage extends StatelessWidget {
  static const routeName = '/error';

  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Center(
        child: Text(l10n.error),
      ),
    );
  }
}
