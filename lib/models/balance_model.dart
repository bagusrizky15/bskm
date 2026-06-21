enum TransactionType {
  deposit('Setoran'),
  withdrawal('Penarikan');

  final String label;
  const TransactionType(this.label);
}

enum WithdrawalStatus {
  pending('Menunggu'),
  approved('Disetujui'),
  rejected('Ditolak');

  final String label;
  const WithdrawalStatus(this.label);

  String get name => toString().split('.').last;
}

class BalanceTransaction {
  final String id;
  final TransactionType type;
  final int amount;
  final double weight;
  final String? category;
  final DateTime date;
  final String description;

  BalanceTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.weight,
    this.category,
    required this.date,
    required this.description,
  });
}

class Balance {
  final String userId;
  final int totalBalance;
  final double totalWaste;
  final int withdrawn;
  final List<BalanceTransaction> transactions;

  Balance({
    required this.userId,
    required this.totalBalance,
    required this.totalWaste,
    required this.withdrawn,
    required this.transactions,
  });
}

class UserBalance {
  final int id;
  final String userId;
  final int total;
  final int withdrawn;
  final int balance;

  UserBalance({
    required this.id,
    required this.userId,
    required this.total,
    required this.withdrawn,
    required this.balance,
  });

  factory UserBalance.fromJson(Map<String, dynamic> json) {
    return UserBalance(
      id: json['id'],
      userId: json['user_id'],
      total: json['total'] ?? 0,
      withdrawn: json['withdrawn'] ?? 0,
      balance: json['balance'] ?? 0,
    );
  }
}

class Withdrawal {
  final int id;
  final String userId;
  final int amount;
  final WithdrawalStatus status;
  final DateTime createdAt;

  Withdrawal({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  factory Withdrawal.fromJson(Map<String, dynamic> json) {
    return Withdrawal(
      id: json['id'],
      userId: json['user_id'],
      amount: json['amount'],
      status: WithdrawalStatus.values.firstWhere(
        (s) => s.toString().split('.').last == json['status'],
        orElse: () => WithdrawalStatus.pending,
      ),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
