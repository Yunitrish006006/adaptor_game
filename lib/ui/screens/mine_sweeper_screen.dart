import 'package:adaptor_games/ui/elements.dart';
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

  void _pauseTimer() {
    if (_timer!.isActive) {
      gameData.paused = true;
      _timer?.cancel();
      setState(() {});
    } else {
      gameData.paused = false;
      _startTimer();
      setState(() {});
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        gameData.time++;
      });
    });
  }

  void _resetTimer() {
    setState(() {
      gameData.time = 0;
    });
    _timer?.cancel();
    _startTimer();
  }

  Widget getContent(BuildContext context, Cell current, MineSweeperGame game) {
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
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: MediaQuery.sizeOf(context).height / 2.4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).hintColor.withAlpha(180),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            gameData.win
                ? AppLocalizations.of(context)!.message_win
                : AppLocalizations.of(context)!.message_lose,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 60,
              color: addEven(Colors.grey, Theme.of(context).canvasColor),
            ),
          ),
          IconButton(
            onPressed: () async {
              await gameData.updateRecord();
              setState(() {
                gameData.resetGame();
                gameData.gameOver = false;
                _resetTimer();
                Navigator.pop(context);
              });
            },
            icon: Icon(
              Icons.refresh,
              size: 64,
              color: addEven(Colors.grey, Theme.of(context).canvasColor),
            ),
          )
        ],
      ),
    );
  }

  Widget getTile(BuildContext context, int index) {
    Cell current = gameData.map[index ~/ gameData.col][index % gameData.col];
    return GestureDetector(
      onTap: gameData.gameOver
          ? () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => getEndGameObject(context));
            }
          : () {
              setState(() {
                if (gameData.mode == "defuse") {
                  gameData.sweepCell(current);
                } else if (gameData.mode == "flag") {
                  gameData.flagCell(current);
                }
                if (gameData.gameOver) {
                  _timer?.cancel();
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          getEndGameObject(context));
                }
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

  AppBar getappBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      toolbarHeight: 40,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      title: Text(AppLocalizations.of(context)!.title_mine_sweeper),
      actions: [
        settingButton(context),
        IconButton(onPressed: _pauseTimer, icon: const Icon(Icons.pause))
      ],
    );
  }

  SizedBox getStatusBar(BuildContext context) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          getStatusField(context, Icons.flag,
              (gameData.getActualMine() - gameData.flagCount).toString(), 3),
          getStatusField(context, Icons.timer, formatTime(gameData.time), 4),
          switchButton(context, gameData)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = getappBar(context);
    SizedBox statusBar = getStatusBar(context);
    double size = MediaQuery.sizeOf(context).height -
        54 -
        appBar.preferredSize.height -
        statusBar.height!;
    return Scaffold(
      appBar: appBar,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          statusBar,
          gameData.paused
              ? Center(
                  child: SizedBox(
                    height: size,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "已暫停",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 40),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  width: double.infinity,
                  height: size,
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
