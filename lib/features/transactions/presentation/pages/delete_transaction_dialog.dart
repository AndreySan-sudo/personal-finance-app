import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/transaction_entity.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';

class DeleteTransactionDialog extends StatelessWidget {
  final TransactionEntity transaction;
  final String userId;

  const DeleteTransactionDialog({
    super.key,
    required this.transaction,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eliminar transacción'),
      content:
          const Text('¿Estás seguro de que deseas eliminar esta transacción?'),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            GetIt.instance<TransactionBloc>().add(
              DeleteTransactionEvent(userId, transaction.id),
            );
            context.pop();
          },
          child: const Text(
            'Eliminar',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
