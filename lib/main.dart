import 'dart:io';
import 'package:adaptor_games/ui/combined_notifier.dart';
import 'package:adaptor_games/ui/screens/auth_gate.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_localizations/firebase_ui_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    List<LocalizationsDelegate<dynamic>> localizationDelegate = [];
    localizationDelegate.addAll(AppLocalizations.localizationsDelegates);
    localizationDelegate.add(FirebaseUILocalizations.delegate);

    return ChangeNotifierProvider(
      create: (_) => CombinedNotifier(
        ThemeMode.system,
        Locale(Platform.localeName.split("_").first,
            Platform.localeName.split("_").last),
      ),
      child: Consumer<CombinedNotifier>(
        builder: (context, notifier, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: notifier.themeMode,
            locale: notifier.currentLocale,
            localizationsDelegates: localizationDelegate,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
