import 'dart:io';
import 'package:adaptor_games/ui/combined_notifier.dart';
import 'package:adaptor_games/ui/screens/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CombinedNotifier(
          ThemeMode.system, Locale(Platform.localeName.split("_").first)),
      child: Consumer<CombinedNotifier>(
        builder: (context, notifier, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: notifier.themeMode,
            locale: notifier.currentLocale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
