class AdminLeaveModel {
  final String id;
  final String userId;
  final String leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status;
  final String employeeName;

  AdminLeaveModel({
    required this.id,
    required this.userId,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.reason,
    required this.status,
    required this.employeeName,
  });

  factory AdminLeaveModel.fromJson(Map<String, dynamic> json) {
    return AdminLeaveModel(
      id: json['id'],
      userId: json['user_id'],
      leaveType: json['leave_type'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      reason: json['reason'],
      status: json['status'],
      employeeName: json['users']['name'],
    );
  }
}
