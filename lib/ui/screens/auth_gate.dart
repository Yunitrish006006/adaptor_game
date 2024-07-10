import 'package:adaptor_games/ui/screens/login_screen.dart';
import 'package:adaptor_games/ui/screens/menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      return const LoginScreen();
    } else {
      return const MenuScreen();
    }
  }
}
