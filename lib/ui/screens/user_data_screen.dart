import 'package:adaptor_games/ui/screens/auth_gate.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  @override
  Widget build(BuildContext context) {
    return ProfileScreen(
      providers: [EmailAuthProvider()],
      actions: [
        SignedOutAction((context) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AuthGate()));
        }),
      ],
    );
  }
}
