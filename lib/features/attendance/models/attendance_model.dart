class AttendanceModel {
  final String id;
  final String userId;
  final DateTime date;
  final DateTime checkIn;
  final DateTime? checkOut;
  final double? totalHours;

  AttendanceModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.checkIn,
    this.checkOut,
    this.totalHours,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      date: DateTime.parse(json['date']),
      checkIn: DateTime.parse(json['check_in']).toUtc(),
      checkOut: json['check_out'] != null
          ? DateTime.parse(json['check_out']).toUtc()
          : null,
      totalHours: json['total_hours']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'date': date.toIso8601String().split('T').first,
      'check_in': checkIn.toIso8601String(),
      'check_out': checkOut?.toIso8601String(),
      'total_hours': totalHours,
    };
  }
}
