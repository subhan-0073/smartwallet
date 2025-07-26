import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() {
  runApp(SmartWallet());
}

class SmartWallet extends StatefulWidget {
  const SmartWallet({super.key});

  @override
  State<SmartWallet> createState() => _SmartWalletState();
}

class _SmartWalletState extends State<SmartWallet> {
  ThemeMode _themeMode = ThemeMode.system;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Wallet',
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: _themeMode,
      home: HomeScreen(toggleTheme: toggleTheme, currentThemeMode: _themeMode),
      debugShowCheckedModeBanner: false,
    );
  }
}
