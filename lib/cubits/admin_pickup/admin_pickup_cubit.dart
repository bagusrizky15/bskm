import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/waste_model.dart';
import 'admin_pickup_state.dart';

class AdminPickupCubit extends Cubit<AdminPickupState> {
  AdminPickupCubit() : super(const AdminPickupInitial()) {
    loadPickups();
  }

  final _supabase = Supabase.instance.client;
  List<WastePickup> _allPickups = [];
  PickupStatus? _selectedFilter;

  Future<void> loadPickups() async {
    emit(const AdminPickupLoading());
    try {
      final pickupsData = await _supabase
          .from('pickups')
          .select()
          .order('created_at', ascending: false);

      final userIds = (pickupsData as List)
          .map((p) => p['user_id'] as String)
          .toSet()
          .toList();

      final usersData = userIds.isEmpty
          ? []
          : await _supabase
              .from('users')
              .select('id, name')
              .inFilter('id', userIds);

      final userMap = {
        for (final u in usersData as List) u['id'] as String: u['name'] as String
      };

      _allPickups = pickupsData.map<WastePickup>((p) {
        return WastePickup(
          id: p['id'].toString(),
          userId: p['user_id'],
          userName: userMap[p['user_id']] ?? 'Unknown',
          category: _parseCategory(p['category']),
          weight: (p['weight'] as num).toDouble(),
          estimatedPrice: (p['price'] as num).toInt(),
          pickupDate: DateTime.parse(p['pickup_date']),
          address: p['pickup_address'] ?? '',
          notes: p['note'],
          status: _parseStatus(p['status']),
        );
      }).toList();

      _emitLoaded();
    } catch (e) {
      emit(AdminPickupFailure(e.toString()));
    }
  }

  void setFilter(PickupStatus? status) {
    _selectedFilter = status;
    _emitLoaded();
  }

  Future<void> confirmPickup(WastePickup pickup) async {
    try {
      // only credit balance on first confirm (from waiting)
      if (pickup.status == PickupStatus.waiting) {
        await _addBalance(pickup.userId, pickup.estimatedPrice);
      }
      await _updateStatus(pickup.id, 'confirmed');
    } catch (e) {
      emit(AdminPickupFailure(e.toString()));
    }
  }

  Future<void> rejectPickup(String pickupId) async {
    await _updateStatus(pickupId, 'rejected');
  }

  Future<void> _addBalance(String userId, int amount) async {
    final existing = await _supabase
        .from('balances')
        .select('total')
        .eq('user_id', userId)
        .maybeSingle();

    if (existing == null) {
      await _supabase
          .from('balances')
          .insert({'user_id': userId, 'total': amount, 'withdrawn': 0});
    } else {
      final current = (existing['total'] as num).toInt();
      await _supabase
          .from('balances')
          .update({'total': current + amount})
          .eq('user_id', userId);
    }
  }

  Future<void> _updateStatus(String pickupId, String status) async {
    try {
      await _supabase
          .from('pickups')
          .update({'status': status})
          .eq('id', pickupId);
      await loadPickups();
    } catch (e) {
      emit(AdminPickupFailure(e.toString()));
    }
  }

  void _emitLoaded() {
    final filtered = _selectedFilter == null
        ? _allPickups
        : _allPickups.where((p) => p.status == _selectedFilter).toList();
    emit(AdminPickupLoaded(pickups: filtered, selectedFilter: _selectedFilter));
  }

  WasteCategory _parseCategory(String? raw) {
    const map = {
      'Plastik': WasteCategory.plastic,
      'Kertas': WasteCategory.paper,
      'Logam': WasteCategory.metal,
      'Kaca': WasteCategory.glass,
      'Elektronik': WasteCategory.electronic,
    };
    return map[raw] ?? WasteCategory.plastic;
  }

  PickupStatus _parseStatus(String? raw) {
    return PickupStatus.values.firstWhere(
      (s) => s.name == raw,
      orElse: () => PickupStatus.waiting,
    );
  }
}
