import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/stats_bloc.dart';
import '../bloc/stats_event.dart';
import '../bloc/stats_state.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return BlocProvider(
      create: (_) => GetIt.instance<StatsBloc>()..add(LoadStatsEvent(user.uid)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Estadísticas')),
        body: BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            if (state is StatsLoading || state is StatsInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatsError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is StatsLoaded) {
              final stats = state.stats;
              final filtered = stats.filteredTransactions;

              return Column(
                children: [
                  _buildFilters(context, stats),
                  const SizedBox(height: 20),
                  if (filtered.isEmpty)
                    const Expanded(
                        child: Center(child: Text('No hay datos para mostrar')))
                  else ...[
                    SizedBox(
                      height: 200,
                      child: PieChart(
                        PieChartData(
                          sections: [
                            if (stats.totalIncome > 0)
                              PieChartSectionData(
                                color: Colors.green,
                                value: stats.totalIncome,
                                title: 'Ingresos',
                                radius: 50,
                              ),
                            if (stats.totalExpense > 0)
                              PieChartSectionData(
                                color: Colors.red,
                                value: stats.totalExpense,
                                title: 'Gastos',
                                radius: 50,
                              ),
                          ],
                          centerSpaceRadius: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildSummary(stats),
                    const Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final t = filtered[index];
                          return ListTile(
                            title: Text(t.title),
                            subtitle: Text(DateFormat.yMMMd().format(t.date)),
                            trailing: Text(
                              '\$${t.amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: t.type == 'income'
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, stats) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownButton<String>(
            value: stats.dateFilter,
            items: const [
              DropdownMenuItem(value: 'this_month', child: Text('Este mes')),
              DropdownMenuItem(value: 'last_month', child: Text('Mes pasado')),
              DropdownMenuItem(value: 'all', child: Text('Todo')),
            ],
            onChanged: (v) =>
                context.read<StatsBloc>().add(ChangeDateFilterEvent(v!)),
          ),
          DropdownButton<String>(
            value: stats.typeFilter,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Todos')),
              DropdownMenuItem(value: 'income', child: Text('Ingresos')),
              DropdownMenuItem(value: 'expense', child: Text('Gastos')),
            ],
            onChanged: (v) =>
                context.read<StatsBloc>().add(ChangeTypeFilterEvent(v!)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(stats) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Ingresos', style: TextStyle(color: Colors.green)),
            Text('\$${stats.totalIncome.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          children: [
            const Text('Gastos', style: TextStyle(color: Colors.red)),
            Text('\$${stats.totalExpense.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          children: [
            const Text('Balance'),
            Text('\$${stats.balance.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
