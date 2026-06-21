import 'package:equatable/equatable.dart';

class CategoryModel {
  final int id;
  final String name;
  final int pricePerKg;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.pricePerKg,
  });
}

abstract class AdminCategoryState extends Equatable {
  const AdminCategoryState();

  @override
  List<Object?> get props => [];
}

class AdminCategoryInitial extends AdminCategoryState {
  const AdminCategoryInitial();
}

class AdminCategoryLoading extends AdminCategoryState {
  const AdminCategoryLoading();
}

class AdminCategoryLoaded extends AdminCategoryState {
  final List<CategoryModel> categories;

  const AdminCategoryLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class AdminCategoryFailure extends AdminCategoryState {
  final String message;

  const AdminCategoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
