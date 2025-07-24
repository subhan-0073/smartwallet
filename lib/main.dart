import 'package:flutter/material.dart';

void main() {
  runApp(SmartWallet());
}

class SmartWallet extends StatelessWidget {
  const SmartWallet({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Center(child: Text("Welcome to Smart Wallet"))),
    );
  }
}
