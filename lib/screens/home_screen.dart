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

  Future<void> _insertMockData() async {
    final mockExpenses = [
      Expense(
        amount: 12.99,
        category: 'Food',
        note: 'Lunch',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Expense(
        amount: 45.00,
        category: 'Transport',
        note: 'Taxi',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Expense(
        amount: 8.50,
        category: 'Coffee',
        note: 'Morning coffee',
        date: DateTime.now(),
      ),
    ];
    for (final expense in mockExpenses) {
      await ExpenseDatabase.instance.insertExpense(expense);
    }
  }

  Future<void> _loadExpenses() async {
    final dbExpenses = await ExpenseDatabase.instance.getExpenses();
    if (dbExpenses.isEmpty) {
      await _insertMockData();
      final newDbExpenses = await ExpenseDatabase.instance.getExpenses();
      setState(() {
        expenses = newDbExpenses;
        isLoading = false;
      });
    } else {
      setState(() {
        expenses = dbExpenses;
        isLoading = false;
      });
    }
  }

  Future<void> _addExpense(Expense expense) async {
    await ExpenseDatabase.instance.insertExpense(expense);
    _loadExpenses();
  }

  Future<void> _deleteExpense(int id) async {
    await ExpenseDatabase.instance.deleteExpense(id);
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
                return Dismissible(
                  key: Key(expense.id.toString()),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Expense'),
                        content: const Text(
                          'Are you sure you want to delete this expense?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) {
                    _deleteExpense(expense.id!);
                  },
                  child: ExpenseTile(
                    amount: expense.amount,
                    category: expense.category,
                    note: expense.note,
                    date: expense.date.toString().split(' ')[0],
                  ),
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
