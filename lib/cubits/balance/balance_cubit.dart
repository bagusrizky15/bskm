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
        balanceData = await Supabase.instance.client
            .from('balances')
            .insert({
              'user_id': userId,
              'total': 0,
              'withdrawn': 0,
            })
            .select()
            .single();
      }

      final withdrawalsData = await Supabase.instance.client
          .from('withdrawals')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      final bankData = await Supabase.instance.client
          .from('bank_accounts')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      final balance = UserBalance.fromJson(balanceData);
      final withdrawals = (withdrawalsData as List)
          .map((w) => Withdrawal.fromJson(w))
          .toList();
      final bankAccount =
          bankData != null ? BankAccount.fromJson(bankData) : null;

      emit(BalanceLoaded(
          balance: balance,
          withdrawals: withdrawals,
          bankAccount: bankAccount));
    } catch (e) {
      emit(BalanceFailure(e.toString()));
    }
  }

  Future<void> saveBankAccount(String nameAccount, String numberAccount) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;
    await Supabase.instance.client.from('bank_accounts').upsert({
      'user_id': userId,
      'name_account': nameAccount,
      'number_account': numberAccount,
    }, onConflict: 'user_id');
    await fetchBalance();
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

      // immediately deduct balance
      final current = state.balance.withdrawn;
      await Supabase.instance.client
          .from('balances')
          .update({'withdrawn': current + amount})
          .eq('user_id', userId);

      emit(const WithdrawalSuccess());
      await fetchBalance();
    } catch (e) {
      emit(BalanceFailure(e.toString()));
    }
  }
}
