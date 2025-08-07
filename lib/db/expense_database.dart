import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      createdBy: expense.createdBy,
    ).toMap();

    expenseWithId.addAll({
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await expensesCollection.doc(generatedId).set(expenseWithId);
  }

  Future<List<Expense>> getExpenses() async {
    final user = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await expensesCollection
        .where('createdBy', isEqualTo: user)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Expense.fromMap(data);
    }).toList();
  }

  Future<void> deleteExpense(String id) async {
    await expensesCollection.doc(id).delete();
  }

  Future<void> updateExpense(Expense expense) async {
    final updatedExpense = expense.toMap();
    updatedExpense.remove('createdAt');
    updatedExpense['updatedAt'] = FieldValue.serverTimestamp();
    await expensesCollection.doc(expense.id).update(updatedExpense);
  }
}
