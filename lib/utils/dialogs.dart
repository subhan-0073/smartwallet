import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../screens/add_expense_screen.dart';

class DialogUtils {
  static Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Expense',
          style: TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text('Are you sure you want to delete this expense?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(color: Colors.lightGreen)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  static void showOptionsDialog(
    BuildContext context,
    Expense expense,
    Function(Expense) onEditExpense,
    Function(Expense) onDeleteExpense,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Expense Options',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final updatedExpense = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddExpenseScreen(expenseToEdit: expense),
                  ),
                );
                if (updatedExpense != null && updatedExpense is Expense) {
                  onEditExpense(updatedExpense);
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.edit, color: Colors.lightGreen),
                  SizedBox(width: 8),
                  Text(
                    'Edit Expense',
                    style: TextStyle(color: Colors.lightGreen, fontSize: 16),
                  ),
                ],
              ),
            ),
            SimpleDialogOption(
              onPressed: () async {
                Navigator.pop(context);
                final shouldDelete = await showDeleteConfirmationDialog(
                  context,
                );
                if (shouldDelete) {
                  onDeleteExpense(expense);
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.delete, color: Colors.redAccent),
                  SizedBox(width: 8),
                  Text(
                    'Delete Expense',
                    style: TextStyle(color: Colors.redAccent, fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
