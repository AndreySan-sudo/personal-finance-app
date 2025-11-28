import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionDatasource datasource;

  TransactionRepositoryImpl(this.datasource);

  @override
  Future<void> addTransaction(
      {required String userId, required TransactionEntity transaction}) async {
    final model = TransactionModel(
      id: transaction.id,
      title: transaction.title,
      description: transaction.description,
      amount: transaction.amount,
      type: transaction.type,
      date: transaction.date,
    );
    await datasource.addTransaction(userId, model.toDocument());
  }

  @override
  Future<void> deleteTransaction(
      {required String userId, required String transactionId}) async {
    await datasource.deleteTransaction(userId, transactionId);
  }

  @override
  Future<void> updateTransaction(
      {required String userId, required TransactionEntity transaction}) async {
    final model = TransactionModel(
      id: transaction.id,
      title: transaction.title,
      description: transaction.description,
      amount: transaction.amount,
      type: transaction.type,
      date: transaction.date,
    );
    await datasource.updateTransaction(
        userId, transaction.id, model.toDocument());
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactionsStream(
      String userId) {
    return datasource.watchTransactions(userId);
  }
}
