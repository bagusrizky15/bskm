class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final bool isAdmin;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    this.isAdmin = false,
  });
}
