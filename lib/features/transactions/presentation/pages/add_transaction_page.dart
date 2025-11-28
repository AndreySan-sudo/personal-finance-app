import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../../../transactions/domain/entities/transaction_entity.dart';

class AddTransactionPage extends StatefulWidget {
  final String userId;
  final TransactionEntity? transaction;

  const AddTransactionPage({
    super.key,
    required this.userId,
    this.transaction,
  });

  @override
  State<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _amountCtrl;
  late String _type;

  @override
  void initState() {
    super.initState();
    final t = widget.transaction;
    _titleCtrl = TextEditingController(text: t?.title ?? '');
    _descCtrl = TextEditingController(text: t?.description ?? '');
    _amountCtrl = TextEditingController(
        text: t != null ? t.amount.toStringAsFixed(2) : '');
    _type = t?.type ?? 'expense';
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;

    return BlocProvider(
      create: (_) => GetIt.instance<TransactionBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text(isEditing ? 'Editar transacción' : 'Agregar transacción'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: 'Título')),
                  TextField(
                      controller: _descCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Descripción')),
                  TextField(
                      controller: _amountCtrl,
                      decoration: const InputDecoration(labelText: 'Monto'),
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: _type,
                    items: const [
                      DropdownMenuItem(value: 'expense', child: Text('Gasto')),
                      DropdownMenuItem(value: 'income', child: Text('Ingreso')),
                    ],
                    onChanged: (v) => setState(() => _type = v ?? 'expense'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final title = _titleCtrl.text.trim();
                      final description = _descCtrl.text.trim();
                      final amount =
                          double.tryParse(_amountCtrl.text.trim()) ?? 0.0;
                      if (title.isEmpty || amount <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Completa los campos correctamente')));
                        return;
                      }

                      final bloc = context.read<TransactionBloc>();

                      if (isEditing) {
                        bloc.add(UpdateTransactionEvent(
                          userId: widget.userId,
                          transactionId: widget.transaction!.id,
                          title: title,
                          description: description,
                          amount: amount,
                          type: _type,
                        ));
                      } else {
                        bloc.add(AddTransactionEvent(
                          userId: widget.userId,
                          title: title,
                          description: description,
                          amount: amount,
                          type: _type,
                        ));
                      }

                      Navigator.of(context).pop();
                    },
                    child: const Text('Guardar'),
                  )
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
