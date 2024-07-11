import 'dart:async';

import 'package:adaptor_games/ui/components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  Timer? _timer;
  String best_12x12 = "";
  String best_16x16 = "";
  String best_16x30 = "";
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      setState(() {});
      best_12x12 = await getSmallestValue("mine_sweep", "of_12x12");
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
        return "$userName:      ${formatTime(smallestDoc.get("time"))}";
      } else {
        return "${smallestDoc.id}:      ${formatTime(smallestDoc.get("time"))}";
      }
    } else {
      return "no record";
    }
  }

  Container surround(Widget content) {
    return Container(
      padding: const EdgeInsets.all(4),
      margin: const EdgeInsets.all(10),
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
      title: const Text(
        // AppLocalizations.of(context)!.title_setting,
        "最高分",
        textAlign: TextAlign.center,
      ),
      content: Column(
        children: [
          surround(const Text("Best of 12x12")),
          surround(Text(best_12x12)),
          surround(const Text("Best of 16x16")),
          surround(Text(best_16x16)),
          surround(const Text("Best of 16x30")),
          surround(Text(best_16x30)),
        ],
      ),
    );
  }
}
