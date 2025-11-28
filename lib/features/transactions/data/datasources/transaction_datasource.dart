import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionDatasource {
  final FirebaseFirestore firestore;

  TransactionDatasource(this.firestore);

  Future<void> addTransaction(String userId, Map<String, dynamic> data) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .add(data);
  }

  Future<void> updateTransaction(
      String userId, String txId, Map<String, dynamic> data) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(txId)
        .update(data);
  }

  Future<void> deleteTransaction(String userId, String txId) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(txId)
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchTransactions(String userId) {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .snapshots();
  }
}
