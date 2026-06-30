class AdminAttendanceModel {
  final String id;
  final String employeeName;
  final DateTime date;
  final DateTime checkIn;
  final DateTime? checkOut;
  final double totalHours;

  AdminAttendanceModel({
    required this.id,
    required this.employeeName,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.totalHours,
  });

  factory AdminAttendanceModel.fromJson(Map<String, dynamic> json) {
    return AdminAttendanceModel(
      id: json['id'],
      employeeName: json['users']['name'],
      date: DateTime.parse(json['date']),
      checkIn: DateTime.parse(json['check_in']),
      checkOut: json['check_out'] == null
          ? null
          : DateTime.parse(json['check_out']),
      totalHours: (json['total_hours'] ?? 0).toDouble(),
    );
  }
}
