import 'package:adaptor_games/common/combined_notifier.dart';
import 'package:adaptor_games/common/components.dart';
import 'package:adaptor_games/ui/screens/score_screen.dart';
import 'package:adaptor_games/utils/color_operation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AppColor {
  static List<Color> letterColors = [
    Colors.transparent,
    Colors.white,
    Colors.blue.shade400,
    Colors.green.shade200,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.red,
    Colors.purple.shade300,
  ];
}

Widget autoSizedText(String content,
    {Color color = Colors.grey, FontWeight fontWeight = FontWeight.normal}) {
  return FittedBox(
    fit: BoxFit.fitWidth,
    child: Text(
      content,
      style: TextStyle(fontSize: 200, color: color, fontWeight: fontWeight),
    ),
  );
}

String formatTime(int seconds) {
  final hours = seconds ~/ (60 * 60);
  seconds = seconds % (60 * 60);
  final minutes = seconds ~/ 60;
  seconds = seconds % 60;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

Future<String?> getUserData(String userId, String field) async {
  DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(userId).get();
  if (snapshot.exists) {
    return snapshot.get(field);
  }
  return null;
}

IconButton settingButton(BuildContext context, {VoidCallback? x}) {
  CombinedNotifier notifier = Provider.of<CombinedNotifier>(context);
  if (x != null) x;
  return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (conytext) => AlertDialog(
            title: Text(
              AppLocalizations.of(context)!.title_setting,
              textAlign: TextAlign.center,
            ),
            content: Column(
              children: [
                languageKit(context, notifier),
                themeModeKit(context, notifier),
                colorThemeKit(context, notifier)
              ],
            ),
          ),
        );
      },
      icon: const Icon(Icons.settings));
}

IconButton scoreBoardButton(BuildContext context) {
  return IconButton(
      onPressed: () async {
        showDialog(
          context: context,
          builder: (conytext) => const ScoreScreen(),
        );
      },
      icon: const Icon(Icons.align_vertical_bottom));
}

Expanded getStatusField(
    BuildContext context, IconData icon, String value, int width) {
  ThemeData theme = Theme.of(context);
  return Expanded(
    flex: width,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: addEven(Colors.grey, theme.hintColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: add3_2(Colors.blue, theme.secondaryHeaderColor),
            size: 32,
          ),
          Text(
            value,
            style: TextStyle(
                color: add4_1(Colors.white, theme.secondaryHeaderColor),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}
