import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/balance_model.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeInitial()) {
    loadBalance();
  }

  late Balance _balance;

  Balance get balance => _balance;

  void loadBalance() {
    emit(const HomeLoading());

    try {
      _balance = Balance(
        userId: '1',
        totalBalance: 45500,
        totalWaste: 12.3,
        withdrawn: 20000,
        transactions: [
          BalanceTransaction(
            id: '1',
            type: TransactionType.deposit,
            amount: 5750,
            weight: 2.3,
            category: 'Plastik',
            date: DateTime(2026, 6, 18),
            description: 'Setoran Plastik',
          ),
          BalanceTransaction(
            id: '2',
            type: TransactionType.deposit,
            amount: 4500,
            weight: 3.0,
            category: 'Kertas',
            date: DateTime(2026, 6, 15),
            description: 'Setoran Kertas',
          ),
          BalanceTransaction(
            id: '3',
            type: TransactionType.withdrawal,
            amount: 20000,
            weight: 0,
            date: DateTime(2026, 6, 10),
            description: 'Penarikan Saldo',
          ),
          BalanceTransaction(
            id: '4',
            type: TransactionType.deposit,
            amount: 7500,
            weight: 1.5,
            category: 'Logam',
            date: DateTime(2026, 6, 5),
            description: 'Setoran Logam',
          ),
          BalanceTransaction(
            id: '5',
            type: TransactionType.deposit,
            amount: 3500,
            weight: 3.5,
            category: 'Kaca',
            date: DateTime(2026, 6, 1),
            description: 'Setoran Kaca',
          ),
        ],
      );
      emit(HomeLoaded(_balance));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> refreshBalance() async {
    emit(const HomeLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(HomeLoaded(_balance));
  }

  Future<void> withdrawBalance(int amount) async {
    emit(const HomeLoading());
    await Future.delayed(const Duration(seconds: 1));

    try {
      _balance = Balance(
        userId: _balance.userId,
        totalBalance: _balance.totalBalance - amount,
        totalWaste: _balance.totalWaste,
        withdrawn: _balance.withdrawn + amount,
        transactions: [
          BalanceTransaction(
            id: '${DateTime.now().millisecondsSinceEpoch}',
            type: TransactionType.withdrawal,
            amount: amount,
            weight: 0,
            date: DateTime.now(),
            description: 'Penarikan Saldo',
          ),
          ..._balance.transactions,
        ],
      );
      emit(HomeLoaded(_balance));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}
