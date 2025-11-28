import 'package:cloud_firestore/cloud_firestore.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repo;
  GetTransactions(this.repo);

  Stream<QuerySnapshot<Map<String, dynamic>>> call(String userId) {
    return repo.getTransactionsStream(userId);
  }
}
