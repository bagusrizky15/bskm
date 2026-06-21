import 'package:equatable/equatable.dart';

class AdminWithdrawal {
  final String id;
  final String userId;
  final String userName;
  final int amount;
  final String status;
  final DateTime createdAt;
  final String? bankName;
  final String? bankNumber;

  const AdminWithdrawal({
    required this.id,
    required this.userId,
    required this.userName,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.bankName,
    this.bankNumber,
  });
}

abstract class AdminBalanceState extends Equatable {
  const AdminBalanceState();

  @override
  List<Object?> get props => [];
}

class AdminBalanceInitial extends AdminBalanceState {
  const AdminBalanceInitial();
}

class AdminBalanceLoading extends AdminBalanceState {
  const AdminBalanceLoading();
}

class AdminBalanceLoaded extends AdminBalanceState {
  final List<AdminWithdrawal> withdrawals;
  final String? filter;

  const AdminBalanceLoaded({required this.withdrawals, this.filter});

  @override
  List<Object?> get props => [withdrawals, filter];
}

class AdminBalanceFailure extends AdminBalanceState {
  final String message;

  const AdminBalanceFailure(this.message);

  @override
  List<Object?> get props => [message];
}
