import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class AuthGate extends StatelessWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentThemeMode;

  const AuthGate({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomeScreen(
            toggleTheme: toggleTheme,
            currentThemeMode: currentThemeMode,
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
