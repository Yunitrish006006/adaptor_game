import 'package:adaptor_games/ui/components.dart';
import 'package:adaptor_games/ui/theme/colors.dart';
import 'package:adaptor_games/utils/color_operation.dart';
import 'package:adaptor_games/utils/game_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class MineSweepGameScreen extends StatefulWidget {
  const MineSweepGameScreen({super.key});

  @override
  State<MineSweepGameScreen> createState() => _MineSweepGameScreenState();
}

class _MineSweepGameScreenState extends State<MineSweepGameScreen> {
  MineSweeperGame gameData = MineSweeperGame();
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    gameData.generateMap();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsElapsed++;
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _secondsElapsed = 0;
    });
    _timer?.cancel();
    _startTimer();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    Widget getContent(
        BuildContext context, Cell current, MineSweeperGame game) {
      if (game.gameOver) {
        if (current.content == "X") {
          return const Text(
            "💣",
            style: TextStyle(fontSize: 32),
          );
        } else if (current.content == "") {
          return Container();
        } else {
          return Text(
            "${current.content}",
            style: TextStyle(
              color: AppColor.letterColors[current.content],
              fontSize: 20,
            ),
          );
        }
      } else {
        if (current.flagged) {
          return const Icon(Icons.flag);
        } else {
          if (current.reveal) {
            return Text(
              "${current.content}",
              style: TextStyle(
                  color: AppColor.letterColors[current.content], fontSize: 20),
            );
          } else {
            return Container();
          }
        }
      }
    }

    Widget getTile(BuildContext context, int index) {
      Cell current = gameData.gameMap[index];
      return GestureDetector(
        onTap: gameData.gameOver
            ? null
            : () {
                setState(() {
                  if (gameData.mode == "defuse") {
                    gameData.sweepCell(current);
                  } else if (gameData.mode == "flag") {
                    gameData.flagCell(current);
                  }
                  if (gameData.gameOver) _timer?.cancel();
                });
              },
        child: Container(
          decoration: BoxDecoration(
            color: current.reveal
                ? add3_2(Colors.grey.shade800, Theme.of(context).hintColor)
                : add4_1(Colors.brown, Theme.of(context).canvasColor),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(child: getContent(context, current, gameData)),
        ),
      );
    }

    Widget switchButton(BuildContext context, MineSweeperGame game) {
      if (game.mode == "defuse") {
        return IconButton(
            onPressed: () {
              setState(() {
                game.mode = "flag";
              });
            },
            icon: const Icon(Icons.cut, size: 32));
      } else {
        return IconButton(
            onPressed: () {
              setState(() {
                game.mode = "defuse";
              });
            },
            icon: const Icon(Icons.flag, size: 32));
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text(AppLocalizations.of(context)!.title_mine_sweeper),
        actions: [settingButton(context)],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getStatusField(context, Icons.flag,
                  (gameData.getActualMine() - gameData.flagCount).toString()),
              getStatusField(
                  context, Icons.timer, _formatTime(_secondsElapsed)),
              switchButton(context, gameData),
            ],
          ),
          Container(
            width: double.infinity,
            height: 520,
            padding: const EdgeInsets.all(20),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MineSweeperGame.row,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: MineSweeperGame.cells,
                itemBuilder: getTile),
          ),
          gameData.gameOver
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      gameData.win
                          ? AppLocalizations.of(context)!.message_win
                          : AppLocalizations.of(context)!.message_lose,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 32),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          gameData.resetGame();
                          gameData.gameOver = false;
                          _resetTimer();
                        });
                      },
                      icon: const Icon(Icons.refresh, size: 40),
                    )
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
