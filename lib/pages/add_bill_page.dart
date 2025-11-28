import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../storage/bill_storage.dart';

// Tela para cadastrar uma nova conta
class AddBillPage extends StatefulWidget {
  const AddBillPage({super.key});

  @override
  State<AddBillPage> createState() => _AddBillPageState();
}

class _AddBillPageState extends State<AddBillPage> {
  final _formKey = GlobalKey<FormState>();
  final _storage = BillStorage();

  // Controladores dos campos de texto
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  final _dueDayController = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    // Limpa os controladores quando a tela for destruída
    _nameController.dispose();
    _valueController.dispose();
    _dueDayController.dispose();
    super.dispose();
  }

  // Valida e salva a conta
  Future<void> _saveBill() async {
    // Valida o formulário
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    // Cria o objeto Bill
    final bill = Bill(
      name: _nameController.text.trim(),
      value: double.parse(_valueController.text.replace(',', '.')),
      dueDay: int.parse(_dueDayController.text),
    );

    // Salva no storage
    await _storage.addBill(bill);

    setState(() {
      _isSaving = false;
    });

    // Retorna para tela anterior informando que salvou
    if (mounted) {
      Navigator.pop(context, true);
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
              // Campo: Nome da conta
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

              // Campo: Valor
              TextFormField(
                controller: _valueController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  hintText: 'Ex: 1500.00',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
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

              // Campo: Dia do vencimento
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

              // Botão: Salvar
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
