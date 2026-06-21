import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'admin_balance_state.dart';

class AdminBalanceCubit extends Cubit<AdminBalanceState> {
  AdminBalanceCubit() : super(const AdminBalanceInitial()) {
    loadWithdrawals();
  }

  final _supabase = Supabase.instance.client;
  List<AdminWithdrawal> _all = [];
  String? _filter;

  Future<void> loadWithdrawals() async {
    emit(const AdminBalanceLoading());
    try {
      final data = await _supabase
          .from('withdrawals')
          .select()
          .order('created_at', ascending: false);

      final userIds = (data as List)
          .map((w) => w['user_id'] as String)
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

      _all = data.map<AdminWithdrawal>((w) {
        return AdminWithdrawal(
          id: w['id'].toString(),
          userId: w['user_id'],
          userName: userMap[w['user_id']] ?? 'Unknown',
          amount: (w['amount'] as num).toInt(),
          status: w['status'] ?? 'pending',
          createdAt: DateTime.parse(w['created_at']),
        );
      }).toList();

      _emitLoaded();
    } catch (e) {
      emit(AdminBalanceFailure(e.toString()));
    }
  }

  void setFilter(String? status) {
    _filter = status;
    _emitLoaded();
  }

  Future<void> approveWithdrawal(AdminWithdrawal withdrawal) async {
    try {
      await _supabase
          .from('withdrawals')
          .update({'status': 'approved'})
          .eq('id', withdrawal.id);

      // increment withdrawn in balances
      final balanceData = await _supabase
          .from('balances')
          .select('withdrawn')
          .eq('user_id', withdrawal.userId)
          .single();

      final current = (balanceData['withdrawn'] as num).toInt();
      await _supabase
          .from('balances')
          .update({'withdrawn': current + withdrawal.amount})
          .eq('user_id', withdrawal.userId);

      await loadWithdrawals();
    } catch (e) {
      emit(AdminBalanceFailure(e.toString()));
    }
  }

  Future<void> rejectWithdrawal(String withdrawalId) async {
    try {
      await _supabase
          .from('withdrawals')
          .update({'status': 'rejected'})
          .eq('id', withdrawalId);
      await loadWithdrawals();
    } catch (e) {
      emit(AdminBalanceFailure(e.toString()));
    }
  }

  void _emitLoaded() {
    final filtered = _filter == null
        ? _all
        : _all.where((w) => w.status == _filter).toList();
    emit(AdminBalanceLoaded(withdrawals: filtered, filter: _filter));
  }
}
