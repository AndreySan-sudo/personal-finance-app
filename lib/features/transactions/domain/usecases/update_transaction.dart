import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repo;
  UpdateTransaction(this.repo);

  Future<void> call(
      {required String userId, required TransactionEntity transaction}) {
    return repo.updateTransaction(userId: userId, transaction: transaction);
  }
}
