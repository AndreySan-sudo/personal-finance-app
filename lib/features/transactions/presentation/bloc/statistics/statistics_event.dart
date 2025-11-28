import 'package:equatable/equatable.dart';
import '../../../../transactions/domain/entities/transaction_entity.dart';

abstract class StatisticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class UpdateTransactionsEvent extends StatisticsEvent {
  final List<TransactionEntity> transactions;
  UpdateTransactionsEvent(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class ChangeDateFilterEvent extends StatisticsEvent {
  final String filter; // 'this_month', 'last_month', 'all'
  ChangeDateFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}

class ChangeTypeFilterEvent extends StatisticsEvent {
  final String filter; // 'all', 'income', 'expense'
  ChangeTypeFilterEvent(this.filter);

  @override
  List<Object?> get props => [filter];
}
