import 'dart:async';

import 'package:adaptor_games/ui/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  Timer? _timer;
  String best_9x9 = "";
  String best_16x16 = "";
  String best_16x30 = "";

  void _startTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1), (timer) async {
      setState(() {});
      best_9x9 = await getSmallestValue("mine_sweep", "of_9x9");
      best_16x16 = await getSmallestValue("mine_sweep", "of_16x16");
      best_16x30 = await getSmallestValue("mine_sweep", "of_16x30");
    });
  }

  Future<String> getSmallestValue(String game, String mode) async {
    CollectionReference scoreboard =
        FirebaseFirestore.instance.collection("score_board");
    QuerySnapshot querySnapshot = await scoreboard
        .doc(game)
        .collection(mode)
        .orderBy("time")
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      DocumentSnapshot smallestDoc = querySnapshot.docs.first;
      String? userName = await getUserData(smallestDoc.id, "name");
      if (userName != null) {
        return "${formatTime(smallestDoc.get("time"))} - $userName";
      }
    }
    return "";
  }

  Container surround(Widget content) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: content,
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.title_score_board,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              surround(Text(
                  AppLocalizations.of(context)!.message_best_record("9x9"))),
              surround(Text(best_9x9)),
            ],
          ),
          Column(
            children: [
              surround(Text(
                  AppLocalizations.of(context)!.message_best_record("16x16"))),
              surround(Text(best_16x16)),
            ],
          ),
          Column(
            children: [
              surround(Text(
                  AppLocalizations.of(context)!.message_best_record("16x30"))),
              surround(Text(best_16x30)),
            ],
          ),
        ],
      ),
    );
  }
}
