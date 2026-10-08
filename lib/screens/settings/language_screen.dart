import 'package:flutter/material.dart';
import '../../l10n/app_strings.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({super.key});
  @override Widget build(BuildContext context) {
    final scope = LanguageScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(scope.tr('language'))),
      body: Column(children: [
        RadioListTile<Locale>(value: const Locale('ps'), groupValue: scope.locale, onChanged: (v) { if (v != null) scope.onChanged(v); }, title: const Text('پښتو')),
        RadioListTile<Locale>(value: const Locale('fa'), groupValue: scope.locale, onChanged: (v) { if (v != null) scope.onChanged(v); }, title: const Text('دری / فارسی')),
        RadioListTile<Locale>(value: const Locale('en'), groupValue: scope.locale, onChanged: (v) { if (v != null) scope.onChanged(v); }, title: const Text('English')),
      ]),
    );
  }
}
