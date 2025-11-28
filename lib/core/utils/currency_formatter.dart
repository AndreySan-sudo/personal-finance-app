import 'package:intl/intl.dart';

String formatCurrency(double amount) {
  final formatter = NumberFormat.currency(locale: 'es_ES', symbol: '\$');
  return formatter.format(amount);
}
