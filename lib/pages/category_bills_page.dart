import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/bill_controller.dart';
import '../models/category.dart';
import '../models/bill.dart';
import 'add_bill_page_new.dart';
import 'edit_bill_page.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            // Avatar com dia do vencimento
            CircleAvatar(
              backgroundColor: bill.isPaid ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
              radius: 24,
              child: Text(
                '${bill.dueDay}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),

            // Informações da conta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    bill.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      decoration: bill.isPaid ? TextDecoration.lineThrough : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'R\$ ${bill.value.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: bill.isPaid ? Colors.green : Colors.red,
                      decoration: bill.isPaid ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
            ),

            // Checkbox
            Checkbox(
              value: bill.isPaid,
              onChanged: (value) {
                ref.read(billControllerProvider.notifier)
                    .togglePaid(bill.id!, value ?? false);
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),

            // Ações (editar e excluir) em coluna
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => _navigateToEdit(context),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.edit, color: Colors.orange, size: 20),
                  ),
                ),
                InkWell(
                  onTap: () => _showDeleteDialog(context, ref),
                  borderRadius: BorderRadius.circular(20),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditBillPage(bill: bill),
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
