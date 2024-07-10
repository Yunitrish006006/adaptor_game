import 'package:adaptor_games/ui/components.dart';
import 'package:adaptor_games/ui/screens/mine_sweeper_screen.dart';
import 'package:adaptor_games/ui/screens/user_data_screen.dart';
import 'package:adaptor_games/utils/mine_sweeper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title_main),
        actions: [settingButton(context)],
      ),
      drawer: const Drawer(child: UserDataScreen()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "遊戲模式",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MineSweepGameScreen(MineSweeperGame(30, 16, 99)),
                  ),
                );
              },
              child: const Text("踩地雷 : 16x30",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MineSweepGameScreen(MineSweeperGame(16, 16, 50)),
                  ),
                );
              },
              child: const Text("踩地雷 : 16x16",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MineSweepGameScreen(MineSweeperGame(12, 12, 30)),
                  ),
                );
              },
              child: const Text("踩地雷 : 12x12",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
