import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_event.dart';
import 'transaction_state.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import '../../../transactions/domain/usecases/get_transactions.dart';
import '../../../transactions/domain/usecases/add_transaction.dart';
import '../../../transactions/domain/usecases/delete_transaction.dart';
import '../../../transactions/domain/usecases/update_transaction.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final GetTransactions getTransactions;
  final AddTransaction addTransaction;
  final DeleteTransaction deleteTransaction;
  final UpdateTransaction updateTransaction;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  TransactionBloc({
    required this.getTransactions,
    required this.addTransaction,
    required this.deleteTransaction,
    required this.updateTransaction,
  }) : super(TransactionInitial()) {
    on<LoadTransactionsEvent>(_onLoad);
    on<_InternalUpdateEvent>(_onInternalUpdate);
    on<AddTransactionEvent>(_onAdd);
    on<DeleteTransactionEvent>(_onDelete);
    on<UpdateTransactionEvent>(_onUpdate);
  }

  Future<void> _onLoad(
      LoadTransactionsEvent event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());

    await _subscription?.cancel();

    _subscription = getTransactions(event.userId).listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        return TransactionEntity.fromMap(doc.id, doc.data());
      }).toList();

      // Se vuelve a enviar como evento interno (válido con Bloc)
      add(_InternalUpdateEvent(list));
    });
  }

  void _onInternalUpdate(
      _InternalUpdateEvent event, Emitter<TransactionState> emit) {
    emit(TransactionLoaded(event.list));
  }

  Future<void> _onAdd(
      AddTransactionEvent event, Emitter<TransactionState> emit) async {
    final t = TransactionEntity(
      id: '',
      title: event.title,
      description: event.description,
      amount: event.amount,
      type: event.type,
      date: DateTime.now(),
    );

    await addTransaction(
      userId: event.userId,
      transaction: t,
    );
  }

  Future<void> _onDelete(
      DeleteTransactionEvent event, Emitter<TransactionState> emit) async {
    await deleteTransaction(
      userId: event.userId,
      transactionId: event.transactionId,
    );
  }

  Future<void> _onUpdate(
      UpdateTransactionEvent event, Emitter<TransactionState> emit) async {
    final t = TransactionEntity(
      id: event.transactionId,
      title: event.title,
      description: event.description,
      amount: event.amount,
      type: event.type,
      date: DateTime.now(),
    );

    await updateTransaction(
      userId: event.userId,
      transaction: t,
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}

// Evento interno — válido porque pasa por un handler normal
class _InternalUpdateEvent extends TransactionEvent {
  final List<TransactionEntity> list;

  _InternalUpdateEvent(this.list);

  @override
  List<Object?> get props => [list];
}
