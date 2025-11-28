import '../entities/stats_entity.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

abstract class StatsRepository {
  StatsEntity calculateStats({
    required List<TransactionEntity> transactions,
    required String dateFilter,
    required String typeFilter,
    DateTime? selectedDate,
  });
}
