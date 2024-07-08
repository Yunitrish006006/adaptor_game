import 'package:flutter/material.dart';

class CombinedNotifier with ChangeNotifier {
  ThemeMode _themeMode;
  Locale _locale;

  CombinedNotifier(this._themeMode, this._locale);

  ThemeMode get themeMode => _themeMode;
  Locale get currentLocale => _locale;

  void updateLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void toggleTheme(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}
