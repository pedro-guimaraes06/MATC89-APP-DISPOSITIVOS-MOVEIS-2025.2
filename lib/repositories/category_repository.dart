import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';

// Repository para gerenciar operações de dados de Category
class CategoryRepository {
  final SupabaseClient _supabase;

  CategoryRepository(this._supabase);

  // CREATE
  Future<Category> create(Category category) async {
    final response = await _supabase
        .from('categories')
        .insert(category.toJson())
        .select()
        .single();
    
    return Category.fromJson(response);
  }

  // READ ALL
  Future<List<Category>> getAll() async {
    final response = await _supabase
        .from('categories')
        .select()
        .order('created_at', ascending: false);
    
    return (response as List)
        .map((json) => Category.fromJson(json))
        .toList();
  }

  // READ ONE
  Future<Category?> getById(String id) async {
    final response = await _supabase
        .from('categories')
        .select()
        .eq('id', id)
        .maybeSingle();
    
    if (response == null) return null;
    return Category.fromJson(response);
  }

  // UPDATE
  Future<Category> update(String id, Category category) async {
    final response = await _supabase
        .from('categories')
        .update(category.toJson())
        .eq('id', id)
        .select()
        .single();
    
    return Category.fromJson(response);
  }

  // DELETE
  Future<void> delete(String id) async {
    await _supabase
        .from('categories')
        .delete()
        .eq('id', id);
  }

  // COUNT bills in category
  Future<int> countBills(String categoryId) async {
    final response = await _supabase
        .from('bills')
        .select('id')
        .eq('category_id', categoryId);
    
    return (response as List).length;
  }
}
