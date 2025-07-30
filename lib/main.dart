import 'package:flutter/material.dart';
import 'screens/auth_gate.dart';
import 'utils/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      home: AuthGate(toggleTheme: toggleTheme, currentThemeMode: _themeMode),
      debugShowCheckedModeBanner: false,
    );
  }
}
