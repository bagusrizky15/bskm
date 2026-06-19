import 'package:equatable/equatable.dart';
import '../../models/balance_model.dart';

abstract class BalanceState extends Equatable {
  const BalanceState();

  @override
  List<Object?> get props => [];
}

class BalanceInitial extends BalanceState {
  const BalanceInitial();
}

class BalanceLoading extends BalanceState {
  const BalanceLoading();
}

class BalanceLoaded extends BalanceState {
  final UserBalance balance;
  final List<Withdrawal> withdrawals;

  const BalanceLoaded({
    required this.balance,
    required this.withdrawals,
  });

  @override
  List<Object?> get props => [balance, withdrawals];
}

class BalanceFailure extends BalanceState {
  final String message;

  const BalanceFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class WithdrawalSubmitting extends BalanceState {
  const WithdrawalSubmitting();
}

class WithdrawalSuccess extends BalanceState {
  const WithdrawalSuccess();
}
