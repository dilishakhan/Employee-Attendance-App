class EmployeeModel {
  final String id;
  final String name;
  final String email;
  final String department;
  final String role;

  EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      department: json['department'] ?? '',
      role: json['role'] ?? '',
    );
  }
}
