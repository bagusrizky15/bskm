import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
    final state = this.state;
    if (state is! PickupFormChanged) {
      emit(const PickupFailure('Invalid form state'));
      return;
    }

    emit(const PickupSubmitting());

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await Supabase.instance.client.from('pickups').insert({
        'user_id': userId,
        'name': name,
        'category': state.selectedCategory,
        'weight': state.weight,
        'price': state.estimatedPrice,
        'pickup_date': state.selectedDate.toIso8601String(),
        'pickup_address': address,
        'note': notes,
        'status': 'waiting',
      });

      emit(const PickupSuccess());
    } catch (e) {
      emit(PickupFailure(e.toString()));
    }
  }

  Future<void> fetchPickups() async {
    emit(const PickupLoading());
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      final data = await Supabase.instance.client
          .from('pickups')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final pickups = (data as List).map((item) {
        final status = PickupStatus.values.firstWhere(
          (s) => s.name == item['status'],
          orElse: () => PickupStatus.waiting,
        );
        return WastePickup(
          id: item['id'].toString(),
          userId: item['user_id'],
          userName: item['name'],
          category: WasteCategory.values.firstWhere(
            (c) => c.name == item['category'],
            orElse: () => WasteCategory.plastic,
          ),
          weight: item['weight'].toDouble(),
          estimatedPrice: item['price'],
          pickupDate: DateTime.parse(item['pickup_date']),
          address: item['pickup_address'],
          notes: item['note'],
          status: status,
        );
      }).toList();

      emit(PickupLoaded(pickups));
    } catch (e) {
      emit(PickupFailure(e.toString()));
    }
  }
}
