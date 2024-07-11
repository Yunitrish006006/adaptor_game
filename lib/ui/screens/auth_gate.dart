import 'package:adaptor_games/ui/screens/login_screen.dart';
import 'package:adaptor_games/ui/screens/menu_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginScreen();
    } else {
      FirebaseFirestore.instance.collection("users").doc(user.uid).set({
        "name": user.displayName,
        "picture": user.photoURL,
      });
      return const MenuScreen();
    }
  }
}
