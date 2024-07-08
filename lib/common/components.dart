import 'package:adaptor_games/common/combined_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

Widget generalKit(BuildContext context, CombinedNotifier notifier,
    DropdownButton child, String title) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20),
            ),
          ),
          child,
        ],
      ),
    ),
  );
}

Widget languageKit(BuildContext context, CombinedNotifier notifier) {
  return generalKit(
      context,
      notifier,
      DropdownButton(
          value: notifier.currentLocale,
          items: const [
            DropdownMenuItem(value: Locale("en"), child: Text("English")),
            DropdownMenuItem(value: Locale("zh"), child: Text("繁體中文")),
          ],
          onChanged: (value) {
            Provider.of<CombinedNotifier>(context, listen: false)
                .updateLocale(value ?? const Locale('en'));
          }),
      AppLocalizations.of(context)!.language);
}

Widget themeKit(BuildContext context, CombinedNotifier notifier) {
  return generalKit(
      context,
      notifier,
      DropdownButton(
          value: notifier.themeMode,
          items: [
            DropdownMenuItem(
                value: ThemeMode.dark,
                child: Text(AppLocalizations.of(context)!.dark)),
            DropdownMenuItem(
                value: ThemeMode.light,
                child: Text(AppLocalizations.of(context)!.light)),
            DropdownMenuItem(
                value: ThemeMode.system,
                child: Text(AppLocalizations.of(context)!.system)),
          ],
          onChanged: (value) {
            Provider.of<CombinedNotifier>(context, listen: false)
                .toggleTheme(value ?? ThemeMode.system);
          }),
      AppLocalizations.of(context)!.theme);
}

Drawer drawer(BuildContext context, CombinedNotifier notifier) {
  return Drawer(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: GridTile(
        child: Column(
          children: [
            languageKit(context, notifier),
            themeKit(context, notifier),
          ],
        ),
      ),
    ),
  );
}
