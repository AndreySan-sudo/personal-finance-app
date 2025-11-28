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
    final currentColor = _type == 'expense' ? Colors.red : Colors.green;

    return BlocProvider(
      create: (_) => GetIt.instance<TransactionBloc>(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title:
                Text(isEditing ? 'Detalle transacción' : 'Agregar transacción'),
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          isEditing
                              ? 'Editar Transacción'
                              : 'Nueva Transacción',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: currentColor,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),
                        SegmentedButton<String>(
                          segments: const [
                            ButtonSegment(
                              value: 'expense',
                              label: Text('Gasto'),
                              icon: Icon(Icons.money_off),
                            ),
                            ButtonSegment(
                              value: 'income',
                              label: Text('Ingreso'),
                              icon: Icon(Icons.attach_money),
                            ),
                          ],
                          selected: {_type},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(() {
                              _type = newSelection.first;
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return currentColor.withOpacity(0.2);
                                }
                                return null;
                              },
                            ),
                            foregroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.selected)) {
                                  return currentColor;
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        TextField(
                          controller: _titleCtrl,
                          decoration: InputDecoration(
                            labelText: 'Título',
                            hintText: 'Ej: Compra de supermercado',
                            prefixIcon: Icon(Icons.title, color: currentColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: currentColor, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _descCtrl,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            hintText: 'Detalles adicionales...',
                            prefixIcon:
                                Icon(Icons.description, color: currentColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: currentColor, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _amountCtrl,
                          decoration: InputDecoration(
                            labelText: 'Monto',
                            prefixIcon:
                                Icon(Icons.attach_money, color: currentColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: currentColor, width: 2),
                            ),
                            filled: true,
                            fillColor: Colors.grey[50],
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                        ),
                        const SizedBox(height: 40),
                        ElevatedButton(
                          onPressed: () {
                            final title = _titleCtrl.text.trim();
                            final description = _descCtrl.text.trim();
                            final amount =
                                double.tryParse(_amountCtrl.text.trim()) ?? 0.0;
                            if (title.isEmpty || amount <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      'Por favor completa los campos requeridos'),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: const Text(
                            'GUARDAR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
