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
import '../../../../core/utils/currency_formatter.dart';

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
          actions: const [
            Tooltip(
              message: 'Mantén presionada una transacción para eliminarla',
              triggerMode: TooltipTriggerMode.tap,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.info_outline),
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Color(0xFFFF6B35),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      user.email ?? 'Usuario',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.add_circle),
                title: const Text('Agregar Transacción'),
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/add');
                },
              ),
              ListTile(
                leading: const Icon(Icons.bar_chart),
                title: const Text('Estadísticas'),
                onTap: () {
                  Navigator.pop(context);
                  GoRouter.of(context).push('/stats');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    GoRouter.of(context).go('/');
                  }
                },
              ),
            ],
          ),
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
                            trailing: Text(formatCurrency(t.amount)),
                            onTap: () {
                              GoRouter.of(context).push('/add', extra: t);
                            },
                            onLongPress: () {
                              context.push(
                                '/delete_transaction',
                                extra: {
                                  'transaction': t,
                                  'userId': user.uid,
                                },
                              );
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
