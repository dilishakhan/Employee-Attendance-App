class UserModel {
  final String id;
  final String name;
  final String email;
  final String department;
  final String role;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      department: json['department'],
      role: json['role'],
      phone: json['phone'] ?? '',
    );
  }
}
