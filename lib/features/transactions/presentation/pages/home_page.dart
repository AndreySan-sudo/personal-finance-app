import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';
import 'add_transaction_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final bloc = GetIt.instance<TransactionBloc>();

    return BlocProvider<TransactionBloc>(
      create: (_) => bloc..add(LoadTransactionsEvent(user.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Historial de Finanzas'),
          actions: [
            IconButton(
              icon: const Icon(Icons.bar_chart),
              onPressed: () => GoRouter.of(context).push('/stats'),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => GoRouter.of(context).push('/add'),
          child: const Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Here you can add totals calculation widgets (income/expense/balance)
              Expanded(
                child: BlocBuilder<TransactionBloc, TransactionState>(
                  builder: (context, state) {
                    if (state is TransactionLoading ||
                        state is TransactionInitial) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TransactionLoaded) {
                      final list = state.transactions;
                      if (list.isEmpty)
                        return const Center(
                            child: Text('No hay transacciones'));
                      return ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (_, i) {
                          final t = list[i];
                          return ListTile(
                            title: Text(t.title),
                            subtitle: Text('${t.type} • ${t.date.toLocal()}'
                                .split('.')
                                .first),
                            trailing: Text('\$${t.amount.toStringAsFixed(2)}'),
                            onTap: () {
                              GoRouter.of(context).push('/add', extra: t);
                            },
                            onLongPress: () {
                              // delete example
                              context
                                  .read<TransactionBloc>()
                                  .add(DeleteTransactionEvent(user.uid, t.id));
                            },
                          );
                        },
                      );
                    } else if (state is TransactionError) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
