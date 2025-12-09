import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/bill_controller.dart';
import '../controllers/category_controller.dart';
import '../models/bill.dart';
import '../services/notification_service.dart';

// Página para adicionar conta (nova versão com Riverpod)
class AddBillPageNew extends ConsumerStatefulWidget {
  final String categoryId;

  const AddBillPageNew({super.key, required this.categoryId});

  @override
  ConsumerState<AddBillPageNew> createState() => _AddBillPageNewState();
}

class _AddBillPageNewState extends ConsumerState<AddBillPageNew> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _dueDayController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  Future<void> _saveBill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final bill = Bill(
      name: _nameController.text.trim(),
      value: double.parse(_valueController.text.replace(',', '.')),
      dueDay: int.parse(_dueDayController.text),
      categoryId: widget.categoryId,
    );

    try {
      await ref.read(billControllerProvider.notifier).addBill(bill);
      
      // Mostra notificação de sucesso
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.showSuccessNotification(
        'Conta "${bill.name}" adicionada com sucesso!',
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Conta'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da conta',
                  hintText: 'Ex: Aluguel, Luz, Água...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o nome da conta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  hintText: 'Ex: 1500.00',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o valor';
                  }
                  final valueFormatted = value.replace(',', '.');
                  if (double.tryParse(valueFormatted) == null) {
                    return 'Valor inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dueDayController,
                decoration: const InputDecoration(
                  labelText: 'Dia do vencimento',
                  hintText: 'Ex: 15',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, informe o dia do vencimento';
                  }
                  final day = int.tryParse(value);
                  if (day == null || day < 1 || day > 31) {
                    return 'Dia inválido (entre 1 e 31)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSaving ? null : _saveBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Salvar Conta',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
