import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? id;
  final double amount;
  final String category;
  final String note;
  final DateTime date;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': Timestamp.fromDate(date),
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount']?.toDouble(),
      category: map['category'],
      note: map['note'],
      date: map['date'].toDate(),
    );
  }
}
