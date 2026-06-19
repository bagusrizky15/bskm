import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/balance_model.dart';
import 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  BalanceCubit() : super(const BalanceInitial());

  Future<void> fetchBalance() async {
    emit(const BalanceLoading());
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      var balanceData = await Supabase.instance.client
          .from('balances')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (balanceData == null) {
        await Supabase.instance.client.from('balances').insert({
          'user_id': userId,
          'balance': 0,
          'total': 0,
          'withdrawn': 0,
        });
        balanceData = {
          'id': null,
          'user_id': userId,
          'balance': 0,
          'total': 0,
          'withdrawn': 0,
        };
      }

      final withdrawalsData = await Supabase.instance.client
          .from('withdrawals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final balance = UserBalance.fromJson(balanceData);
      final withdrawals = (withdrawalsData as List)
          .map((w) => Withdrawal.fromJson(w))
          .toList();

      emit(BalanceLoaded(balance: balance, withdrawals: withdrawals));
    } catch (e) {
      emit(BalanceFailure(e.toString()));
    }
  }

  Future<void> requestWithdrawal(int amount) async {
    final state = this.state;
    if (state is! BalanceLoaded) {
      emit(const BalanceFailure('Invalid state'));
      return;
    }

    if (amount <= 0 || amount > state.balance.balance) {
      emit(const BalanceFailure('Saldo tidak cukup'));
      return;
    }

    emit(const WithdrawalSubmitting());
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not logged in');

      await Supabase.instance.client.from('withdrawals').insert({
        'user_id': userId,
        'amount': amount,
        'status': 'pending',
      });

      emit(const WithdrawalSuccess());
      await fetchBalance();
    } catch (e) {
      emit(BalanceFailure(e.toString()));
    }
  }
}
