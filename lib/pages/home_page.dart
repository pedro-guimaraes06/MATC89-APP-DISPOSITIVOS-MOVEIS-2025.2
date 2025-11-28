import 'package:flutter/material.dart';
import '../models/bill.dart';
import '../storage/bill_storage.dart';
import 'add_bill_page.dart';

// Tela principal que lista todas as contas cadastradas
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BillStorage _storage = BillStorage();
  List<Bill> _bills = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  // Carrega as contas salvas
  Future<void> _loadBills() async {
    setState(() {
      _isLoading = true;
    });

    final bills = await _storage.loadBills();

    setState(() {
      _bills = bills;
      _isLoading = false;
    });
  }

  // Remove uma conta
  Future<void> _removeBill(int index) async {
    await _storage.removeBill(index);
    _loadBills(); // Recarrega a lista
  }

  // Navega para tela de adicionar conta
  void _navigateToAddBill() async {
    // Aguarda retorno da tela de cadastro
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddBillPage()),
    );

    // Se uma conta foi adicionada, recarrega a lista
    if (result == true) {
      _loadBills();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kill Bills'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bills.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhuma conta cadastrada.\nToque no + para adicionar.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _bills.length,
                  itemBuilder: (context, index) {
                    final bill = _bills[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          child: Text('${bill.dueDay}'),
                        ),
                        title: Text(
                          bill.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Vencimento: dia ${bill.dueDay}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'R\$ ${bill.value.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Confirmação antes de deletar
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Remover conta'),
                                    content: Text(
                                      'Deseja remover "${bill.name}"?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _removeBill(index);
                                        },
                                        child: const Text(
                                          'Remover',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddBill,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
