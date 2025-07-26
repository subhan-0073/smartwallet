import 'package:flutter/material.dart';
import '../screens/add_expense_screen.dart';
import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import '../db/expense_database.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentThemeMode;

  const HomeScreen({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
  });

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

  IconData _getThemeIcon() {
    return widget.currentThemeMode == ThemeMode.light
        ? Icons.dark_mode
        : Icons.light_mode;
  }

  String _getThemeTooltip() {
    return widget.currentThemeMode == ThemeMode.light
        ? 'Switch to Dark Mode'
        : 'Switch to Light Mode';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Wallet'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_getThemeIcon()),
            onPressed: widget.toggleTheme,
            tooltip: _getThemeTooltip(),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 24),
                  Text(
                    'Loading your expenses...',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            )
          : expenses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wallet_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No expenses yet!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add your first expense.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            )
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
                  onDismissed: (direction) async {
                    await _deleteExpense(expense.id!);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Expense deleted'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            await _addExpense(expense);
                          },
                        ),
                      ),
                    );
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
