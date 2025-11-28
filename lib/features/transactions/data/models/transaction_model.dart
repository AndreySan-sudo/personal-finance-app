import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  TransactionModel({
    required String id,
    required String title,
    String description = '',
    required double amount,
    required String type,
    required DateTime date,
  }) : super(
            id: id,
            title: title,
            description: description,
            amount: amount,
            type: type,
            date: date);

  Map<String, dynamic> toDocument() {
    return {
      'title': title,
      'description': description,
      'amount': amount,
      'type': type,
      'date': Timestamp.fromDate(date),
    };
  }

  factory TransactionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return TransactionModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      type: data['type'] ?? 'gasto',
      date: (data['date'] is Timestamp)
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  factory TransactionModel.fromMap(String id, Map<String, dynamic> data) {
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

    return TransactionModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      amount: amount,
      type: data['type'] ?? 'expense',
      date: date,
    );
  }
}
