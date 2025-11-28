import '../entities/stats_entity.dart';
import '../repositories/stats_repository.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class GetStats {
  final StatsRepository repository;

  GetStats(this.repository);

  StatsEntity call({
    required List<TransactionEntity> transactions,
    required String dateFilter,
    required String typeFilter,
    DateTime? selectedDate,
  }) {
    return repository.calculateStats(
      transactions: transactions,
      dateFilter: dateFilter,
      typeFilter: typeFilter,
      selectedDate: selectedDate,
    );
  }
}
