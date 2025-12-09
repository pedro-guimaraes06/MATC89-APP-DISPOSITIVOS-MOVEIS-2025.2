import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bill.dart';

// Repository para gerenciar operações de dados de Bill
class BillRepository {
  final SupabaseClient _supabase;

  BillRepository(this._supabase);

  // CREATE
  Future<Bill> create(Bill bill) async {
    final response = await _supabase
        .from('bills')
        .insert(bill.toJson())
        .select()
        .single();
    
    return Bill.fromJson(response);
  }

  // READ ALL
  Future<List<Bill>> getAll() async {
    final response = await _supabase
        .from('bills')
        .select()
        .order('due_day', ascending: true);
    
    return (response as List)
        .map((json) => Bill.fromJson(json))
        .toList();
  }

  // READ BY CATEGORY (demonstra relação 1:N)
  Future<List<Bill>> getByCategory(String categoryId) async {
    final response = await _supabase
        .from('bills')
        .select()
        .eq('category_id', categoryId)
        .order('due_day', ascending: true);
    
    return (response as List)
        .map((json) => Bill.fromJson(json))
        .toList();
  }

  // READ ONE
  Future<Bill?> getById(String id) async {
    final response = await _supabase
        .from('bills')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return Bill.fromJson(response);
  }

  // UPDATE
  Future<Bill> update(String id, Bill bill) async {
    final response = await _supabase
        .from('bills')
        .update(bill.toJson())
        .eq('id', id)
        .select()
        .single();
    
    return Bill.fromJson(response);
  }

  // DELETE
  Future<void> delete(String id) async {
    await _supabase
        .from('bills')
        .delete()
        .eq('id', id);
  }

  // Toggle paid status
  Future<Bill> togglePaid(String id, bool isPaid) async {
    final response = await _supabase
        .from('bills')
        .update({'is_paid': isPaid})
        .eq('id', id)
        .select()
        .single();
    
    return Bill.fromJson(response);
  }
}
