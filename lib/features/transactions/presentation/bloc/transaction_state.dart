import 'package:equatable/equatable.dart';
// import 'package:finances_app/features/transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<TransactionEntity> transactions;
  TransactionLoaded(this.transactions);

  @override
  List<Object?> get props => [transactions];
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);

  @override
  List<Object?> get props => [message];
}
