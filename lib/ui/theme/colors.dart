import 'package:flutter/material.dart';

class AppColor {
  static List<Color> letterColors = [
    Colors.white,
    Colors.blue.shade400,
    Colors.green.shade200,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.red,
    Colors.purple.shade300,
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
