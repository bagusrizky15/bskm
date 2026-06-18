class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    this.isAdmin = false,
  });

  // Add this method
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      isAdmin: json['is_admin'] ?? false,
    );
  }
}
