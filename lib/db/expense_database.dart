import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../models/expense.dart';

class ExpenseFirestore {
  static final ExpenseFirestore instance = ExpenseFirestore._instance();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _uuid = Uuid();

  ExpenseFirestore._instance();

  final CollectionReference expensesCollection = _firestore.collection(
    'expenses',
  );

  Future<void> insertExpense(Expense expense) async {
    final generatedId = _uuid.v4();

    final expenseWithId = Expense(
      id: generatedId,
      amount: expense.amount,
      category: expense.category,
      note: expense.note,
      date: expense.date,
    );

    await expensesCollection.doc(generatedId).set(expenseWithId.toMap());
  }

  Future<List<Expense>> getExpenses() async {
    final querySnapshot = await expensesCollection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Expense.fromMap({'id': doc.id, ...data});
    }).toList();
  }

  Future<void> deleteExpense(String id) async {
    await expensesCollection.doc(id).delete();
  }

  Future<void> updateExpense(Expense expense) async {
    await expensesCollection.doc(expense.id).update(expense.toMap());
  }
}
