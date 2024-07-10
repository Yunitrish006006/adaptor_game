import 'package:adaptor_games/ui/screens/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SignInScreen(
      providers: [EmailAuthProvider()],
      actions: [
        AuthStateChangeAction<SignedIn>((context, state) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const AuthGate()));
        }),
      ],
    );
  }
}
