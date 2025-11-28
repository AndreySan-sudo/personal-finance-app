import '../../domain/entities/stats_entity.dart';
import '../../domain/repositories/stats_repository.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class StatsRepositoryImpl implements StatsRepository {
  @override
  StatsEntity calculateStats({
    required List<TransactionEntity> transactions,
    required String dateFilter,
    required String typeFilter,
  }) {
    // Apply filters
    final filtered = _filterTransactions(
      transactions: transactions,
      dateFilter: dateFilter,
      typeFilter: typeFilter,
    );

    // Calculate totals
    final totalIncome = filtered
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);

    final totalExpense = filtered
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    return StatsEntity(
      filteredTransactions: filtered,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
      dateFilter: dateFilter,
      typeFilter: typeFilter,
    );
  }

  List<TransactionEntity> _filterTransactions({
    required List<TransactionEntity> transactions,
    required String dateFilter,
    required String typeFilter,
  }) {
    final now = DateTime.now();

    return transactions.where((t) {
      // Date Filter
      bool dateMatch = true;
      if (dateFilter == 'this_month') {
        dateMatch = t.date.year == now.year && t.date.month == now.month;
      } else if (dateFilter == 'last_month') {
        final lastMonth = DateTime(now.year, now.month - 1);
        dateMatch =
            t.date.year == lastMonth.year && t.date.month == lastMonth.month;
      }

      // Type Filter
      bool typeMatch = true;
      if (typeFilter != 'all') {
        typeMatch = t.type == typeFilter;
      }

      return dateMatch && typeMatch;
    }).toList();
  }
}
