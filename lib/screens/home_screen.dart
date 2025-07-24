import 'package:flutter/material.dart';
import '../screens/add_expense_screen.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import '../db/expense_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Expense> expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final dbExpenses = await ExpenseDatabase.instance.getExpenses();
    setState(() {
      expenses = dbExpenses;
      isLoading = false;
    });
  }

  Future<void> _addExpense(Expense expense) async {
    await ExpenseDatabase.instance.insertExpense(expense);
    _loadExpenses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Wallet'), centerTitle: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : expenses.isEmpty
          ? const Center(child: Text('No expenses yet.'))
          : ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final expense = expenses[index];
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

          if (newExpense != null && newExpense is Expense) {
            await _addExpense(newExpense);
          }
        },
        tooltip: 'Add Expense',
        child: const Icon(Icons.add),
      ),
    );
  }
}
