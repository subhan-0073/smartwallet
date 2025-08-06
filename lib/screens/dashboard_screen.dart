import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartwallet/models/expense.dart';
import 'package:smartwallet/screens/add_expense_screen.dart';
import '../widgets/expense_tile.dart';
import '../db/expense_database.dart';
import '../utils/dialogs.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentThemeMode;
  const DashboardScreen({
    super.key,
    required this.toggleTheme,
    required this.currentThemeMode,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Expense> expenses = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    final dbExpenses = await ExpenseFirestore.instance.getExpenses();
    if (!mounted) return;
    setState(() {
      expenses = dbExpenses;
      isLoading = false;
    });
  }

  Future<void> _addExpense(Expense expense) async {
    await ExpenseFirestore.instance.insertExpense(expense);
    _loadExpenses();
  }

  Future<void> _deleteExpense(String id) async {
    await ExpenseFirestore.instance.deleteExpense(id);
    _loadExpenses();
  }

  Future<void> _editExpense(Expense expense) async {
    await ExpenseFirestore.instance.updateExpense(expense);
    _loadExpenses();
  }

  void _showOptionsDialog(Expense expense) {
    DialogUtils.showOptionsDialog(context, expense, _editExpense, (
      expense,
    ) async {
      await _deleteExpense(expense.id!);
      if (!mounted) return;
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
    });
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
        title: Text("Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_getThemeIcon()),
            onPressed: widget.toggleTheme,
            tooltip: _getThemeTooltip(),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 24),
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
                  SizedBox(height: 16),
                  Text(
                    'No expenses yet!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  SizedBox(height: 8),
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
                  direction: DismissDirection.horizontal,
                  background: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.edit, color: Colors.lightGreen, size: 28),
                        SizedBox(width: 8),
                        Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.lightGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                  secondaryBackground: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Text(
                          'Delete',
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.delete, color: Colors.redAccent, size: 28),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.startToEnd) {
                      // Edit
                      final updatedExpense = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddExpenseScreen(expenseToEdit: expense),
                        ),
                      );
                      if (updatedExpense != null && updatedExpense is Expense) {
                        await _editExpense(updatedExpense);
                      }
                      return false;
                    } else if (direction == DismissDirection.endToStart) {
                      // Delete
                      return await DialogUtils.showDeleteConfirmationDialog(
                        context,
                      );
                    }
                    return false;
                  },
                  onDismissed: (direction) async {
                    if (direction == DismissDirection.endToStart) {
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
                    }
                  },
                  child: GestureDetector(
                    onLongPress: () => _showOptionsDialog(expense),
                    child: ExpenseTile(
                      amount: expense.amount,
                      category: expense.category,
                      note: expense.note,
                      date: expense.date.toString().split(' ')[0],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newExpense = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddExpenseScreen()),
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
