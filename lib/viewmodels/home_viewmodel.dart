import 'package:flutter/material.dart';
import '../models/balance_model.dart';

class HomeViewModel extends ChangeNotifier {
  late Balance _balance;
  bool _isLoading = false;

  Balance get balance => _balance;
  bool get isLoading => _isLoading;

  HomeViewModel() {
    _initializeBalance();
  }

  void _initializeBalance() {
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
  }

  Future<void> refreshBalance() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> withdrawBalance(int amount) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

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

    _isLoading = false;
    notifyListeners();
  }
}
