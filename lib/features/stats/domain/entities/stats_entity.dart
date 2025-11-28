import 'package:equatable/equatable.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class StatsEntity extends Equatable {
  final List<TransactionEntity> filteredTransactions;
  final double totalIncome;
  final double totalExpense;
  final String dateFilter; // 'this_month', 'last_month', 'all'
  final String typeFilter; // 'all', 'income', 'expense'
  final DateTime? selectedDate;

  const StatsEntity({
    required this.filteredTransactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.dateFilter,
    required this.typeFilter,
    this.selectedDate,
  });

  double get balance => totalIncome - totalExpense;

  @override
  List<Object?> get props => [
        filteredTransactions,
        totalIncome,
        totalExpense,
        dateFilter,
        typeFilter,
        selectedDate,
      ];
}
