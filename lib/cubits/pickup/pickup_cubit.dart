import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/waste_model.dart';
import 'pickup_state.dart';

class PickupCubit extends Cubit<PickupState> {
  PickupCubit() : super(const PickupInitial());

  Future<void> submitPickup({
    required String name,
    required String category,
    required double weight,
    required int price,
    required DateTime pickupDate,
    required String address,
    String? notes,
  }) async {
    emit(const PickupSubmitting());

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await Supabase.instance.client.from('pickups').insert({
        'user_id': userId,
        'name': name,
        'category': category,
        'weight': weight,
        'price': price,
        'pickup_date': pickupDate.toIso8601String(),
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
          category: item['category'] ?? '',
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
