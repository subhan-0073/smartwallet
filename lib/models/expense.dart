import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  final String? id;
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Expense({
    this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': Timestamp.fromDate(date),
      'createdBy': createdBy,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount']?.toDouble(),
      category: map['category'],
      note: map['note'],
      date: map['date'].toDate(),
      createdBy: map['createdBy'] ?? '',
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }
}
