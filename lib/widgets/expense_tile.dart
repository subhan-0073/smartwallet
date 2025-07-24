import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  final double amount;
  final String category;
  final String note;
  final String date;

  const ExpenseTile({
    super.key,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(category[0])),
        title: Text(category),
        subtitle: Text(note),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('₹${amount.toStringAsFixed(2)}'),
            Text(
              date,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
