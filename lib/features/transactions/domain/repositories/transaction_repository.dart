import 'package:cloud_firestore/cloud_firestore.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<void> addTransaction(
      {required String userId, required TransactionEntity transaction});
  Future<void> updateTransaction(
      {required String userId, required TransactionEntity transaction});
  Future<void> deleteTransaction(
      {required String userId, required String transactionId});
  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactionsStream(
      String userId);
}
