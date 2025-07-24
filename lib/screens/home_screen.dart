import 'package:flutter/material.dart';
import '../widgets/expense_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> mockExpenses = [
    {
      'amount': 12.99,
      'category': 'Food',
      'note': 'Lunch',
      'date': '2025-07-24',
    },
    {
      'amount': 45.00,
      'category': 'Transport',
      'note': 'Taxi',
      'date': '2025-07-23',
    },
    {
      'amount': 8.50,
      'category': 'Coffee',
      'note': 'Morning coffee',
      'date': '2025-07-23',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Wallet'), centerTitle: true),
      body: ListView.builder(
        itemCount: mockExpenses.length,
        itemBuilder: (context, index) {
          final expense = mockExpenses[index];
          return ExpenseTile(
            amount: expense['amount'],
            category: expense['category'],
            note: expense['note'],
            date: expense['date'],
          );
        },
      ),
    );
  }
}
