enum WasteCategory {
  plastic('Plastik', 2500),
  paper('Kertas', 1500),
  metal('Logam', 5000),
  glass('Kaca', 1000),
  electronic('Elektronik', 7500);

  final String name;
  final int pricePerKg;

  const WasteCategory(this.name, this.pricePerKg);
}

class WastePickup {
  final String id;
  final String userId;
  final String userName;
  final WasteCategory category;
  final double weight;
  final int estimatedPrice;
  final DateTime pickupDate;
  final String address;
  final String? notes;
  final PickupStatus status;

  WastePickup({
    required this.id,
    required this.userId,
    required this.userName,
    required this.category,
    required this.weight,
    required this.estimatedPrice,
    required this.pickupDate,
    required this.address,
    this.notes,
    required this.status,
  });
}

enum PickupStatus {
  waiting('Menunggu'),
  confirmed('Dikonfirmasi'),
  rejected('Ditolak'),
  completed('Selesai');

  final String label;
  const PickupStatus(this.label);
}
