import 'package:equatable/equatable.dart';
import '../../../../transactions/domain/entities/transaction_entity.dart';

class StatisticsState extends Equatable {
  final String filterDate;
  final String filterType;
  final List<TransactionEntity> filteredTransactions;
  final double totalIncome;
  final double totalExpense;

  const StatisticsState({
    this.filterDate = 'this_month',
    this.filterType = 'all',
    this.filteredTransactions = const [],
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
  });

  StatisticsState copyWith({
    String? filterDate,
    String? filterType,
    List<TransactionEntity>? filteredTransactions,
    double? totalIncome,
    double? totalExpense,
  }) {
    return StatisticsState(
      filterDate: filterDate ?? this.filterDate,
      filterType: filterType ?? this.filterType,
      filteredTransactions: filteredTransactions ?? this.filteredTransactions,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
    );
  }

  @override
  List<Object?> get props =>
      [filterDate, filterType, filteredTransactions, totalIncome, totalExpense];
}
