import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_stats.dart';
import '../../../transactions/domain/usecases/get_transactions.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import 'stats_event.dart';
import 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  final GetStats getStats;
  final GetTransactions getTransactions;

  String _currentDateFilter = 'this_month';
  String _currentTypeFilter = 'all';
  DateTime? _selectedDate;
  String _userId = '';

  StatsBloc({
    required this.getStats,
    required this.getTransactions,
  }) : super(StatsInitial()) {
    on<LoadStatsEvent>(_onLoadStats);
    on<ChangeDateFilterEvent>(_onChangeDateFilter);
    on<ChangeTypeFilterEvent>(_onChangeTypeFilter);
  }

  Future<void> _onLoadStats(
      LoadStatsEvent event, Emitter<StatsState> emit) async {
    try {
      emit(StatsLoading());
      _userId = event.userId;

      final transactionsStream = getTransactions(_userId);
      final snapshot = await transactionsStream.first;
      final transactions = _convertToTransactionList(snapshot);

      final stats = getStats(
        transactions: transactions,
        dateFilter: _currentDateFilter,
        typeFilter: _currentTypeFilter,
        selectedDate: _selectedDate,
      );

      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  Future<void> _onChangeDateFilter(
      ChangeDateFilterEvent event, Emitter<StatsState> emit) async {
    try {
      _currentDateFilter = event.filter;
      if (event.customDate != null) {
        _selectedDate = event.customDate;
      }

      final transactionsStream = getTransactions(_userId);
      final snapshot = await transactionsStream.first;
      final transactions = _convertToTransactionList(snapshot);

      final stats = getStats(
        transactions: transactions,
        dateFilter: _currentDateFilter,
        typeFilter: _currentTypeFilter,
        selectedDate: _selectedDate,
      );

      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  Future<void> _onChangeTypeFilter(
      ChangeTypeFilterEvent event, Emitter<StatsState> emit) async {
    try {
      _currentTypeFilter = event.filter;

      final transactionsStream = getTransactions(_userId);
      final snapshot = await transactionsStream.first;
      final transactions = _convertToTransactionList(snapshot);

      final stats = getStats(
        transactions: transactions,
        dateFilter: _currentDateFilter,
        typeFilter: _currentTypeFilter,
        selectedDate: _selectedDate,
      );

      emit(StatsLoaded(stats));
    } catch (e) {
      emit(StatsError(e.toString()));
    }
  }

  List<TransactionEntity> _convertToTransactionList(snapshot) {
    return snapshot.docs
        .map<TransactionEntity>((doc) => TransactionEntity.fromMap(
            doc.id, doc.data() as Map<String, dynamic>))
        .toList();
  }
}
