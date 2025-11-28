import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/stats_bloc.dart';
import '../bloc/stats_event.dart';
import '../bloc/stats_state.dart';
import '../../../../core/utils/currency_formatter.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return BlocProvider(
      create: (_) => GetIt.instance<StatsBloc>()..add(LoadStatsEvent(user.uid)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Estadísticas'),
          elevation: 0,
        ),
        body: BlocBuilder<StatsBloc, StatsState>(
          builder: (context, state) {
            if (state is StatsLoading || state is StatsInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error: ${state.message}'),
                  ],
                ),
              );
            } else if (state is StatsLoaded) {
              final stats = state.stats;
              final filtered = stats.filteredTransactions;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Filters Section with Title
                    Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 4, bottom: 12),
                            child: Row(
                              children: [
                                const Icon(Icons.filter_alt, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Filtros',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildFilters(context, stats),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (filtered.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(Icons.inbox_outlined,
                                size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'No hay datos para mostrar',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      )
                    else ...[
                      // Pie Chart Card (PRIMERO)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          color: Colors.grey[100],
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const Text(
                                  'Distribución',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 220,
                                  child: _buildPieChart(stats),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Summary Cards (SEGUNDO)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: _buildSummaryCards(stats),
                      ),

                      const SizedBox(height: 24),

                      // Transactions List
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            const Icon(Icons.list_alt, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Transacciones (${filtered.length})',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final t = filtered[index];
                          return Card(
                            color: Colors.grey[100],
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: t.type == 'income'
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                                child: Icon(
                                  t.type == 'income'
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                                  color: t.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              title: Text(
                                t.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (t.description.isNotEmpty)
                                    Text(
                                      t.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  Text(
                                    DateFormat.yMMMd().format(t.date),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                              trailing: Text(
                                formatCurrency(t.amount),
                                style: TextStyle(
                                  color: t.type == 'income'
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, stats) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6),
                child: Text(
                  'Filtrar por mes',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: stats.dateFilter,
                    isExpanded: true,
                    icon: const Icon(Icons.calendar_today, size: 20),
                    items: [
                      const DropdownMenuItem(
                        value: 'this_month',
                        child: Text('Este mes'),
                      ),
                      const DropdownMenuItem(
                        value: 'last_month',
                        child: Text('Mes pasado'),
                      ),
                      const DropdownMenuItem(
                        value: 'all',
                        child: Text('Todo'),
                      ),
                      DropdownMenuItem(
                        value: 'custom',
                        child: Text(stats.dateFilter == 'custom' &&
                                stats.selectedDate != null
                            ? DateFormat.yMMMM('es').format(stats.selectedDate!)
                            : 'Personalizado'),
                      ),
                    ],
                    onChanged: (v) async {
                      if (v == 'custom') {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                          locale: const Locale('es', 'ES'),
                          helpText: 'Selecciona un mes',
                        );
                        if (picked != null) {
                          if (context.mounted) {
                            context.read<StatsBloc>().add(ChangeDateFilterEvent(
                                'custom',
                                customDate: picked));
                          }
                        }
                      } else {
                        context
                            .read<StatsBloc>()
                            .add(ChangeDateFilterEvent(v!));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 6),
                child: Text(
                  'Filtrar por categoría',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: stats.typeFilter,
                    isExpanded: true,
                    icon: const Icon(Icons.filter_list, size: 20),
                    items: const [
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('Todos'),
                      ),
                      DropdownMenuItem(
                        value: 'income',
                        child: Text('Ingresos'),
                      ),
                      DropdownMenuItem(
                        value: 'expense',
                        child: Text('Gastos'),
                      ),
                    ],
                    onChanged: (v) => context
                        .read<StatsBloc>()
                        .add(ChangeTypeFilterEvent(v!)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCards(stats) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Ingresos',
            stats.totalIncome,
            Colors.green,
            Icons.trending_up,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Gastos',
            stats.totalExpense,
            Colors.red,
            Icons.trending_down,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Balance',
            stats.balance,
            stats.balance >= 0 ? Colors.blue : Colors.orange,
            Icons.account_balance_wallet,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
      String title, double amount, Color color, IconData icon) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatCurrency(amount),
                style: TextStyle(
                  color: color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(stats) {
    if (stats.totalIncome == 0 && stats.totalExpense == 0) {
      return const Center(
        child: Text('No hay datos para mostrar'),
      );
    }

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: PieChart(
            PieChartData(
              sections: [
                if (stats.totalIncome > 0)
                  PieChartSectionData(
                    color: Colors.green,
                    value: stats.totalIncome,
                    title:
                        '${((stats.totalIncome / (stats.totalIncome + stats.totalExpense)) * 100).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                if (stats.totalExpense > 0)
                  PieChartSectionData(
                    color: Colors.red,
                    value: stats.totalExpense,
                    title:
                        '${((stats.totalExpense / (stats.totalIncome + stats.totalExpense)) * 100).toStringAsFixed(1)}%',
                    radius: 60,
                    titleStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
              ],
              sectionsSpace: 2,
              centerSpaceRadius: 40,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stats.totalIncome > 0)
                _buildLegendItem('Ingresos', Colors.green, stats.totalIncome),
              if (stats.totalIncome > 0 && stats.totalExpense > 0)
                const SizedBox(height: 12),
              if (stats.totalExpense > 0)
                _buildLegendItem('Gastos', Colors.red, stats.totalExpense),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, double amount) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                formatCurrency(amount),
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
