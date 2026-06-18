enum TransactionType {
  deposit('Setoran'),
  withdrawal('Penarikan');

  final String label;
  const TransactionType(this.label);
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
