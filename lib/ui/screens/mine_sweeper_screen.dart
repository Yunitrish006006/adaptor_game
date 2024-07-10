import 'package:adaptor_games/ui/components.dart';
import 'package:adaptor_games/ui/theme/colors.dart';
import 'package:adaptor_games/utils/color_operation.dart';
import 'package:adaptor_games/utils/mine_sweeper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:async';

class MineSweepGameScreen extends StatefulWidget {
  const MineSweepGameScreen(this.game, {super.key});

  final MineSweeperGame game;

  @override
  State<MineSweepGameScreen> createState() => _MineSweepGameScreenState();
}

class _MineSweepGameScreenState extends State<MineSweepGameScreen> {
  late MineSweeperGame gameData;
  Timer? _timer;
  int _secondsElapsed = 0;

  @override
  void initState() {
    gameData = widget.game;
    super.initState();
    gameData.resetGame();
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
          return autoSizedText("💣");
        } else if (current.content == "") {
          return Container();
        } else {
          return autoSizedText("${current.content}",
              color: AppColor.letterColors[current.content]);
        }
      } else {
        if (current.flagged) {
          return FittedBox(
            fit: BoxFit.fitWidth,
            child: Icon(
              Icons.flag,
              color:
                  add4_1(Colors.red, Theme.of(context).primaryIconTheme.color!),
            ),
          );
        } else {
          if (current.reveal) {
            if (current.content is int) {
              return autoSizedText("${current.content}",
                  color: AppColor.letterColors[current.content]);
            } else {
              if (current.content == "X") {
                return autoSizedText("💣");
              } else {
                return Container();
              }
            }
          } else {
            return Container();
          }
        }
      }
    }

    Widget getEndGameObject(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gameData.win
                ? AppLocalizations.of(context)!.message_win
                : AppLocalizations.of(context)!.message_lose,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                gameData.resetGame();
                gameData.gameOver = false;
                _resetTimer();
                Navigator.pop(context);
              });
            },
            icon: const Icon(Icons.refresh, size: 40),
          )
        ],
      );
    }

    Widget getTile(BuildContext context, int index) {
      Cell current = gameData.map[index ~/ gameData.col][index % gameData.col];
      return GestureDetector(
        onTap: gameData.gameOver
            ? () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        getEndGameObject(context));
              }
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
            icon: const Icon(Icons.cut));
      } else {
        return IconButton(
            onPressed: () {
              setState(() {
                game.mode = "defuse";
              });
            },
            icon: const Icon(Icons.flag));
      }
    }

    AppBar appBar = AppBar(
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 40,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: Text(AppLocalizations.of(context)!.title_mine_sweeper),
      actions: [settingButton(context)],
    );

    SizedBox statusBar = SizedBox(
      height: 30,
      child: Row(
        children: [
          getStatusField(context, Icons.flag,
              (gameData.getActualMine() - gameData.flagCount).toString(), 3),
          getStatusField(context, Icons.timer, _formatTime(_secondsElapsed), 4),
          switchButton(context, gameData)
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          statusBar,
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height -
                24 -
                appBar.preferredSize.height -
                statusBar.height!,
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gameData.col,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: gameData.cells(),
                itemBuilder: getTile),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
