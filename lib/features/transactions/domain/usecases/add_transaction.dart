import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class AddTransaction {
  final TransactionRepository repo;
  AddTransaction(this.repo);

  Future<void> call(
      {required String userId, required TransactionEntity transaction}) {
    return repo.addTransaction(userId: userId, transaction: transaction);
  }
}
