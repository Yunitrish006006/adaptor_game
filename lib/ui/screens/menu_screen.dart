import 'package:adaptor_games/ui/components.dart';
import 'package:adaptor_games/ui/screens/mine_sweeper_screen.dart';
import 'package:adaptor_games/ui/screens/user_data_screen.dart';
import 'package:adaptor_games/utils/color_operation.dart';
import 'package:adaptor_games/utils/mine_sweeper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Widget getGameModeButton(BuildContext context, Widget game, String title) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => game,
          ),
        );
      },
      child: Text(
        title,
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: add3_2(Colors.grey, Theme.of(context).highlightColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_main),
        actions: [settingButton(context), scoreBOardButton(context)],
      ),
      drawer: const Drawer(child: UserDataScreen()),
      body: Center(
        child: Column(
          children: [
            const Text(
              "遊戲模式",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getGameModeButton(
                  context,
                  MineSweepGameScreen(MineSweeperGame(30, 16, 99)),
                  "踩地雷 : 16x30",
                ),
                getGameModeButton(
                  context,
                  MineSweepGameScreen(MineSweeperGame(16, 16, 50)),
                  "踩地雷 : 16x16",
                ),
                getGameModeButton(
                  context,
                  MineSweepGameScreen(MineSweeperGame(12, 12, 30)),
                  "踩地雷 : 12x12",
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
