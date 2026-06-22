import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_category_state.dart';

class AdminCategoryCubit extends Cubit<AdminCategoryState> {
  AdminCategoryCubit() : super(const AdminCategoryInitial()) {
    loadCategories();
  }

  final _supabase = Supabase.instance.client;

  Future<void> loadCategories() async {
    emit(const AdminCategoryLoading());
    try {
      final data = await _supabase
          .from('categories')
          .select()
          .order('id');

      final categories = (data as List).map<CategoryModel>((c) {
        return CategoryModel(
          id: (c['id'] as num).toInt(),
          name: c['category'] as String,
          pricePerKg: (c['price_per_kg'] as num).toInt(),
          isArchived: c['is_archived'] as bool? ?? false,
        );
      }).toList();

      emit(AdminCategoryLoaded(categories));
    } catch (e) {
      emit(AdminCategoryFailure(e.toString()));
    }
  }

  Future<void> addCategory(String name, int pricePerKg) async {
    try {
      await _supabase.from('categories').insert({
        'category': name,
        'price_per_kg': pricePerKg,
      });
      await loadCategories();
    } catch (e) {
      emit(AdminCategoryFailure(e.toString()));
    }
  }

  Future<void> updateCategory(int id, int pricePerKg) async {
    try {
      await _supabase
          .from('categories')
          .update({'price_per_kg': pricePerKg})
          .eq('id', id);
      await loadCategories();
    } catch (e) {
      emit(AdminCategoryFailure(e.toString()));
    }
  }

  Future<void> archiveCategory(int id, {required bool archive}) async {
    try {
      await _supabase
          .from('categories')
          .update({'is_archived': archive})
          .eq('id', id);
      await loadCategories();
    } catch (e) {
      emit(AdminCategoryFailure(e.toString()));
    }
  }
}
