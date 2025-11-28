import 'package:equatable/equatable.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  final String userId;
  LoadTransactionsEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddTransactionEvent extends TransactionEvent {
  final String userId;
  final String title;
  final String description;
  final double amount;
  final String type;
  AddTransactionEvent(
      {required this.userId,
      required this.title,
      this.description = '',
      required this.amount,
      required this.type});

  @override
  List<Object?> get props => [userId, title, description, amount, type];
}

class DeleteTransactionEvent extends TransactionEvent {
  final String userId;
  final String transactionId;
  DeleteTransactionEvent(this.userId, this.transactionId);

  @override
  List<Object?> get props => [userId, transactionId];
}

class UpdateTransactionEvent extends TransactionEvent {
  final String userId;
  final String transactionId;
  final String title;
  final String description;
  final double amount;
  final String type;
  UpdateTransactionEvent({
    required this.userId,
    required this.transactionId,
    required this.title,
    this.description = '',
    required this.amount,
    required this.type,
  });

  @override
  List<Object?> get props =>
      [userId, transactionId, title, description, amount, type];
}
