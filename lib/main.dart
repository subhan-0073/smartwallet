import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(SmartWallet());
}

class SmartWallet extends StatelessWidget {
  const SmartWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Wallet',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF43A047)),
      ),

      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
