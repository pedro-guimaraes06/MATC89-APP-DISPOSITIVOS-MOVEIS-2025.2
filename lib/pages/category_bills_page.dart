import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/bill_controller.dart';
import '../models/category.dart';
import '../models/bill.dart';
import 'add_bill_page_new.dart';

// Página que mostra todas as contas de uma categoria específica (demonstra relação 1:N)
class CategoryBillsPage extends ConsumerWidget {
  final Category category;

  const CategoryBillsPage({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billsAsync = ref.watch(billsByCategoryProvider(category.id!));

    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
        backgroundColor: Color(int.parse('0xFF${category.color}')),
        foregroundColor: Colors.white,
      ),
      body: billsAsync.when(
        data: (bills) {
          if (bills.isEmpty) {
            return const Center(
              child: Text(
                'Nenhuma conta nesta categoria.\nToque no + para adicionar.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: bills.length,
            itemBuilder: (context, index) {
              final bill = bills[index];
              return _BillCard(bill: bill, category: category);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Erro: $error',
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddBillPageNew(categoryId: category.id!),
            ),
          );
        },
        backgroundColor: Color(int.parse('0xFF${category.color}')),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BillCard extends ConsumerWidget {
  final Bill bill;
  final Category category;

  const _BillCard({required this.bill, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: bill.isPaid ? Colors.green : Colors.red,
          foregroundColor: Colors.white,
          child: Text('${bill.dueDay}'),
        ),
        title: Text(
          bill.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: bill.isPaid ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(
          'Vencimento: dia ${bill.dueDay}',
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'R\$ ${bill.value.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: bill.isPaid ? Colors.green : Colors.red,
                    decoration: bill.isPaid ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
            Checkbox(
              value: bill.isPaid,
              onChanged: (value) {
                ref.read(billControllerProvider.notifier)
                    .togglePaid(bill.id!, value ?? false);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover conta'),
        content: Text('Deseja remover "${bill.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(billControllerProvider.notifier).deleteBill(bill.id!);
            },
            child: const Text(
              'Remover',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
