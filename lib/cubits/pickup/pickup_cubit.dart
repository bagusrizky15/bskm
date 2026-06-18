import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/waste_model.dart';
import 'pickup_state.dart';

class PickupCubit extends Cubit<PickupState> {
  PickupCubit()
      : super(PickupFormChanged(
          selectedCategory: 'Plastik',
          weight: 2.5,
          estimatedPrice: 6250,
          selectedDate: DateTime(2026, 6, 20),
        ));

  String get selectedCategory {
    final state = this.state;
    return state is PickupFormChanged ? state.selectedCategory : 'Plastik';
  }

  double get weight {
    final state = this.state;
    return state is PickupFormChanged ? state.weight : 2.5;
  }

  DateTime get selectedDate {
    final state = this.state;
    return state is PickupFormChanged
        ? state.selectedDate
        : DateTime(2026, 6, 20);
  }

  int get estimatedPrice {
    final state = this.state;
    return state is PickupFormChanged ? state.estimatedPrice : 6250;
  }

  void setCategory(String category) {
    final state = this.state;
    if (state is PickupFormChanged) {
      final category2 = WasteCategory.values
          .firstWhere((c) => c.name == category);
      final newPrice = (category2.pricePerKg * state.weight).toInt();
      emit(PickupFormChanged(
        selectedCategory: category,
        weight: state.weight,
        estimatedPrice: newPrice,
        selectedDate: state.selectedDate,
      ));
    }
  }

  void setWeight(double weight) {
    final state = this.state;
    if (state is PickupFormChanged) {
      final category = WasteCategory.values
          .firstWhere((c) => c.name == state.selectedCategory);
      final newPrice = (category.pricePerKg * weight).toInt();
      emit(PickupFormChanged(
        selectedCategory: state.selectedCategory,
        weight: weight,
        estimatedPrice: newPrice,
        selectedDate: state.selectedDate,
      ));
    }
  }

  void setDate(DateTime date) {
    final state = this.state;
    if (state is PickupFormChanged) {
      emit(PickupFormChanged(
        selectedCategory: state.selectedCategory,
        weight: state.weight,
        estimatedPrice: state.estimatedPrice,
        selectedDate: date,
      ));
    }
  }

  Future<void> submitPickup(
    String name,
    String address,
    String? notes,
  ) async {
    emit(const PickupSubmitting());
    await Future.delayed(const Duration(seconds: 1));

    try {
      emit(const PickupSuccess());
    } catch (e) {
      emit(PickupFailure(e.toString()));
    }
  }
}
