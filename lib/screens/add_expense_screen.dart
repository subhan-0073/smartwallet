import 'package:flutter/material.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expenseToEdit;

  const AddExpenseScreen({super.key, this.expenseToEdit});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  double? _amount;
  String? _category;
  String? _note;
  DateTime? _selectedDate = DateTime.now();

  final _formKey = GlobalKey<FormState>();
  bool _isFormValid = false;
  bool get _isEditMode => widget.expenseToEdit != null;

  void _validateForm() {
    final isValid = _formKey.currentState?.validate() ?? false;
    setState(() {
      _isFormValid = isValid && _selectedDate != null;
    });
  }

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_validateForm);
    _categoryController.addListener(_validateForm);
    _noteController.addListener(_validateForm);

    if (_isEditMode) {
      final expense = widget.expenseToEdit!;
      _amountController.text = expense.amount.toString();
      _categoryController.text = expense.category;
      _noteController.text = expense.note;
      _selectedDate = expense.date;
      _validateForm();
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditMode ? 'Edit Expense' : 'Add Expense')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            Text(
              'Enter expense details',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _amountController,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: const Icon(Icons.currency_rupee),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Amount is required';
                }
                final parsed = double.tryParse(value);
                if (parsed == null) {
                  return 'Invalid amount';
                }
                if (parsed <= 0) {
                  return 'Amount must be greater than 0';
                }
                return null;
              },
              onSaved: (newValue) => _amount = double.tryParse(newValue ?? ''),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _categoryController,
              decoration: InputDecoration(
                labelText: 'Category',
                prefixIcon: const Icon(Icons.category),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Category is required';
                }
                return null;
              },
              onSaved: (newValue) => _category = newValue?.trim(),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Note',
                prefixIcon: const Icon(Icons.edit),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              maxLength: 100,
              validator: (value) {
                if (value != null && value.length > 100) {
                  return 'Note must be at most 100 characters';
                }
                return null;
              },
              onSaved: (newValue) => _note = newValue?.trim(),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate == null
                    ? 'Select Date'
                    : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                textStyle: Theme.of(context).textTheme.bodyLarge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                  _validateForm();
                }
              },
            ),
            if (_selectedDate == null)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Text(
                  'Date is required',
                  style: TextStyle(color: Colors.red[700], fontSize: 13),
                ),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(_isEditMode ? Icons.save : Icons.add),
                label: Text(_isEditMode ? 'Update Expense' : 'Add Expense'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _isFormValid
                    ? () {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          _formKey.currentState?.save();
                          final expense = Expense(
                            id: _isEditMode ? widget.expenseToEdit!.id : null,
                            amount: _amount ?? 0,
                            category: _category ?? '',
                            note: _note ?? '',
                            date: _selectedDate!,
                          );
                          Navigator.pop(context, expense);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isEditMode
                                    ? 'Expense updated successfully!'
                                    : 'Expense added successfully!',
                              ),
                            ),
                          );
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
