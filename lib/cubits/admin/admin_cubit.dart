import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_state.dart';

class AdminCubit extends Cubit<AdminState> {
  AdminCubit() : super(const AdminInitial()) {
    loadStats();
  }

  final _supabase = Supabase.instance.client;

  Future<void> loadStats() async {
    emit(const AdminLoading());
    try {
      final usersCount = await _supabase
          .from('users')
          .select('id')
          .count();

      final pickupsData = await _supabase
          .from('pickups')
          .select('weight');

      final totalWeight = (pickupsData as List)
          .fold<double>(0, (sum, p) => sum + (p['weight'] as num).toDouble());

      emit(AdminLoaded(
        totalUsers: usersCount.count,
        totalWaste: totalWeight.round(),
      ));
    } catch (e) {
      emit(AdminFailure(e.toString()));
    }
  }
}
