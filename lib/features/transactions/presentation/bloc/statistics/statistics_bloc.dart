import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../transactions/domain/entities/transaction_entity.dart';
import '../transaction_bloc.dart';
import '../transaction_state.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final TransactionBloc transactionBloc;
  late StreamSubscription _transactionSubscription;
  List<TransactionEntity> _allTransactions = [];

  StatisticsBloc({required this.transactionBloc})
      : super(const StatisticsState()) {
    on<UpdateTransactionsEvent>(_onUpdateTransactions);
    on<ChangeDateFilterEvent>(_onChangeDateFilter);
    on<ChangeTypeFilterEvent>(_onChangeTypeFilter);

    // Initial load if already loaded
    if (transactionBloc.state is TransactionLoaded) {
      add(UpdateTransactionsEvent(
          (transactionBloc.state as TransactionLoaded).transactions));
    }

    _transactionSubscription = transactionBloc.stream.listen((state) {
      if (state is TransactionLoaded) {
        add(UpdateTransactionsEvent(state.transactions));
      }
    });
  }

  void _onUpdateTransactions(
      UpdateTransactionsEvent event, Emitter<StatisticsState> emit) {
    _allTransactions = event.transactions;
    _applyFilters(emit);
  }

  void _onChangeDateFilter(
      ChangeDateFilterEvent event, Emitter<StatisticsState> emit) {
    emit(state.copyWith(filterDate: event.filter));
    _applyFilters(emit);
  }

  void _onChangeTypeFilter(
      ChangeTypeFilterEvent event, Emitter<StatisticsState> emit) {
    emit(state.copyWith(filterType: event.filter));
    _applyFilters(emit);
  }

  void _applyFilters(Emitter<StatisticsState> emit) {
    final now = DateTime.now();
    final filtered = _allTransactions.where((t) {
      // Date Filter
      bool dateMatch = true;
      if (state.filterDate == 'this_month') {
        dateMatch = t.date.year == now.year && t.date.month == now.month;
      } else if (state.filterDate == 'last_month') {
        final lastMonth = DateTime(now.year, now.month - 1);
        dateMatch =
            t.date.year == lastMonth.year && t.date.month == lastMonth.month;
      }

      // Type Filter
      bool typeMatch = true;
      if (state.filterType != 'all') {
        typeMatch = t.type == state.filterType;
      }

      return dateMatch && typeMatch;
    }).toList();

    final totalIncome = filtered
        .where((t) => t.type == 'income')
        .fold(0.0, (sum, t) => sum + t.amount);
    final totalExpense = filtered
        .where((t) => t.type == 'expense')
        .fold(0.0, (sum, t) => sum + t.amount);

    emit(state.copyWith(
      filteredTransactions: filtered,
      totalIncome: totalIncome,
      totalExpense: totalExpense,
    ));
  }

  @override
  Future<void> close() {
    _transactionSubscription.cancel();
    return super.close();
  }
}
