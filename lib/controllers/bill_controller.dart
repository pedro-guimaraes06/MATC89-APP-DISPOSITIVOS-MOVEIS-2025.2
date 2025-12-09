import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bill.dart';
import '../repositories/bill_repository.dart';

part 'bill_controller.g.dart';

// Provider para o repository
@riverpod
BillRepository billRepository(BillRepositoryRef ref) {
  return BillRepository(Supabase.instance.client);
}

// Controller para gerenciar estado de bills
@riverpod
class BillController extends _$BillController {
  @override
  Future<List<Bill>> build() async {
    return await _fetchBills();
  }

  Future<List<Bill>> _fetchBills() async {
    final repository = ref.read(billRepositoryProvider);
    return await repository.getAll();
  }

  // CREATE
  Future<void> addBill(Bill bill) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(billRepositoryProvider);
      await repository.create(bill);
      return await _fetchBills();
    });
  }

  // UPDATE
  Future<void> updateBill(String id, Bill bill) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(billRepositoryProvider);
      await repository.update(id, bill);
      return await _fetchBills();
    });
  }

  // DELETE
  Future<void> deleteBill(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(billRepositoryProvider);
      await repository.delete(id);
      return await _fetchBills();
    });
  }

  // TOGGLE PAID
  Future<void> togglePaid(String id, bool isPaid) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(billRepositoryProvider);
      await repository.togglePaid(id, isPaid);
      return await _fetchBills();
    });
  }

  // Refresh
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _fetchBills();
    });
  }
}

// Provider para bills por categoria (demonstra relação 1:N)
@riverpod
Future<List<Bill>> billsByCategory(BillsByCategoryRef ref, String categoryId) async {
  final repository = ref.watch(billRepositoryProvider);
  return await repository.getByCategory(categoryId);
}
