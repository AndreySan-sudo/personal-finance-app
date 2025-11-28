import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import '../bloc/statistics/statistics_bloc.dart';
import '../bloc/statistics/statistics_event.dart';
import '../bloc/statistics/statistics_state.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<StatisticsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Estadísticas')),
        body: BlocBuilder<StatisticsBloc, StatisticsState>(
          builder: (context, state) {
            final filtered = state.filteredTransactions;
            final totalIncome = state.totalIncome;
            final totalExpense = state.totalExpense;

            return Column(
              children: [
                _buildFilters(context, state),
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
                          if (totalIncome > 0)
                            PieChartSectionData(
                              color: Colors.green,
                              value: totalIncome,
                              title: 'Ingresos',
                              radius: 50,
                            ),
                          if (totalExpense > 0)
                            PieChartSectionData(
                              color: Colors.red,
                              value: totalExpense,
                              title: 'Gastos',
                              radius: 50,
                            ),
                        ],
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSummary(totalIncome, totalExpense),
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
          },
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, StatisticsState state) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          DropdownButton<String>(
            value: state.filterDate,
            items: const [
              DropdownMenuItem(value: 'this_month', child: Text('Este mes')),
              DropdownMenuItem(value: 'last_month', child: Text('Mes pasado')),
              DropdownMenuItem(value: 'all', child: Text('Todo')),
            ],
            onChanged: (v) =>
                context.read<StatisticsBloc>().add(ChangeDateFilterEvent(v!)),
          ),
          DropdownButton<String>(
            value: state.filterType,
            items: const [
              DropdownMenuItem(value: 'all', child: Text('Todos')),
              DropdownMenuItem(value: 'income', child: Text('Ingresos')),
              DropdownMenuItem(value: 'expense', child: Text('Gastos')),
            ],
            onChanged: (v) =>
                context.read<StatisticsBloc>().add(ChangeTypeFilterEvent(v!)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(double income, double expense) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            const Text('Ingresos', style: TextStyle(color: Colors.green)),
            Text('\$${income.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          children: [
            const Text('Gastos', style: TextStyle(color: Colors.red)),
            Text('\$${expense.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        Column(
          children: [
            const Text('Balance'),
            Text('\$${(income - expense).toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
