import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/admin_service.dart';

final adminServiceProvider = Provider((ref) => AdminService());

final employeeCountProvider = FutureProvider<int>((ref) async {
  return ref.read(adminServiceProvider).getEmployeeCount();
});

final pendingLeaveProvider = FutureProvider<int>((ref) async {
  return ref.read(adminServiceProvider).getPendingLeaveCount();
});

final attendanceCountProvider = FutureProvider<int>((ref) async {
  return ref.read(adminServiceProvider).getTodayAttendanceCount();
});
