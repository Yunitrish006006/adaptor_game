import 'package:flutter/material.dart';

class AppColor {
  static Color primaryColor = const Color(0xff1f1b18);
  static Color secondaryColor = const Color(0xffdd6e41);
  static Color accentColor = const Color(0xff7a9eb8);
  static Color lightPrimaryColor = const Color(0xff3f3a36);
  static Color clickedCard = const Color(0xff818181);

  static List<Color> letterColors = [
    Colors.white,
    Colors.blue.shade100,
    Colors.greenAccent,
    Colors.green,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.red,
  ];

  ThemeData getTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.purple,
        brightness: Brightness.dark,
      ),
    );
  }
}
