import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_attendance_model.dart';
import '../services/admin_attendance_service.dart';

final adminAttendanceServiceProvider = Provider(
  (ref) => AdminAttendanceService(),
);

final attendanceOverviewProvider = FutureProvider<List<AdminAttendanceModel>>((
  ref,
) async {
  return ref.read(adminAttendanceServiceProvider).getAttendance();
});
