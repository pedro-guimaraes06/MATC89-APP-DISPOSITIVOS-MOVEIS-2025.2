import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/bill_controller.dart';
import '../models/bill.dart';
import '../services/notification_service.dart';

// Página para editar conta existente
class EditBillPage extends ConsumerStatefulWidget {
  final Bill bill;

  const EditBillPage({super.key, required this.bill});

  @override
  ConsumerState<EditBillPage> createState() => _EditBillPageState();
}

class _EditBillPageState extends ConsumerState<EditBillPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _valueController;
  late final TextEditingController _dueDayController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Inicializa os controllers com os dados da conta existente
    _nameController = TextEditingController(text: widget.bill.name);
    _valueController = TextEditingController(
      text: widget.bill.value.toStringAsFixed(2),
    );
    _dueDayController = TextEditingController(
      text: widget.bill.dueDay.toString(),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _valueController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  Future<void> _updateBill() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final updatedBill = Bill(
      id: widget.bill.id,
      name: _nameController.text.trim(),
      value: double.parse(_valueController.text.replaceAll(',', '.')),
      dueDay: int.parse(_dueDayController.text),
      categoryId: widget.bill.categoryId,
      isPaid: widget.bill.isPaid,
      createdAt: widget.bill.createdAt,
    );

    try {
      await ref.read(billControllerProvider.notifier)
          .updateBill(widget.bill.id!, updatedBill);

      // Mostra notificação de sucesso
      try {
        final notificationService = ref.read(notificationServiceProvider);
        await notificationService.showSuccessNotification(
          'Conta "${updatedBill.name}" atualizada com sucesso!',
        );
        debugPrint('✅ Notificação de atualização enviada com sucesso');
      } catch (notificationError) {
        debugPrint('⚠️ Erro ao enviar notificação: $notificationError');
        // Continua mesmo se a notificação falhar
      }

      if (mounted) {
        // Mostra também um SnackBar como fallback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Conta "${updatedBill.name}" atualizada com sucesso!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('❌ Erro ao atualizar conta: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar: $e')),
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
        title: const Text('Editar Conta'),
        backgroundColor: Colors.orange,
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
                  final valueFormatted = value.replaceAll(',', '.');
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
                onPressed: _isSaving ? null : _updateBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
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
                        'Salvar Alterações',
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

