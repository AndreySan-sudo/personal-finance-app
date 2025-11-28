import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionEntity {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String type; // "entrada" | "gasto"
  final DateTime date;

  TransactionEntity({
    required this.id,
    required this.title,
    this.description = '',
    required this.amount,
    required this.type,
    required this.date,
  });

  factory TransactionEntity.fromMap(String id, Map<String, dynamic> data) {
    final timestamp = data['date'];
    DateTime date;
    if (timestamp is Timestamp) {
      date = timestamp.toDate();
    } else if (timestamp is DateTime) {
      date = timestamp;
    } else {
      date = DateTime.now();
    }

    final amountRaw = data['amount'];
    double amount;
    if (amountRaw is int)
      amount = amountRaw.toDouble();
    else if (amountRaw is double)
      amount = amountRaw;
    else
      amount = double.tryParse(amountRaw?.toString() ?? '') ?? 0.0;

    return TransactionEntity(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: amount,
      type: data['type'] ?? 'expense',
      date: date,
    );
  }
}
