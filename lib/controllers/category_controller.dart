import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category.dart';
import '../repositories/category_repository.dart';

part 'category_controller.g.dart';

// Provider para o repository
@riverpod
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepository(Supabase.instance.client);
}

// Controller para gerenciar estado de categorias
@riverpod
class CategoryController extends _$CategoryController {
  @override
  Future<List<Category>> build() async {
    return await _fetchCategories();
  }

  Future<List<Category>> _fetchCategories() async {
    final repository = ref.read(categoryRepositoryProvider);
    return await repository.getAll();
  }

  // CREATE
  Future<void> addCategory(Category category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.create(category);
      return await _fetchCategories();
    });
  }

  // UPDATE
  Future<void> updateCategory(String id, Category category) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.update(id, category);
      return await _fetchCategories();
    });
  }

  // DELETE
  Future<void> deleteCategory(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(categoryRepositoryProvider);
      await repository.delete(id);
      return await _fetchCategories();
    });
  }

  // Refresh
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await _fetchCategories();
    });
  }
}

// Provider para contar bills por categoria
@riverpod
Future<int> categoryBillCount(Ref ref, String categoryId) async {
  final repository = ref.watch(categoryRepositoryProvider);
  return await repository.countBills(categoryId);
}
