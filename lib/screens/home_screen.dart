import 'package:flutter/material.dart';
import '../screens/add_expense_screen.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Expense> mockExpenses = [
    Expense(
      amount: 12.99,
      category: 'Food',
      note: 'Lunch',
      date: DateTime.parse('2025-07-24'),
    ),
    Expense(
      amount: 45.00,
      category: 'Transport',
      note: 'Taxi',
      date: DateTime.parse('2025-07-23'),
    ),
    Expense(
      amount: 8.50,
      category: 'Coffee',
      note: 'Morning coffee',
      date: DateTime.parse('2025-07-23'),
    ),
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
            amount: expense.amount,
            category: expense.category,
            note: expense.note,
            date: expense.date.toString().split(' ')[0],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
          );

          if (newExpense != null) {
            setState(() {
              mockExpenses.add(newExpense);
            });
          }
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
