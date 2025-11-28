import '../repositories/transaction_repository.dart';

class DeleteTransaction {
  final TransactionRepository repo;
  DeleteTransaction(this.repo);

  Future<void> call({required String userId, required String transactionId}) {
    return repo.deleteTransaction(userId: userId, transactionId: transactionId);
  }
}
