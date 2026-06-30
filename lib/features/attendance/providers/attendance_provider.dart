import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/attendance_model.dart';
import '../repository/attendance_repository.dart';

/// Repository Provider
final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  return AttendanceRepository();
});

/// Today's Attendance
final attendanceProvider = FutureProvider<AttendanceModel?>((ref) async {
  return ref.read(attendanceRepositoryProvider).getTodayAttendance();
});

/// Attendance History
final attendanceHistoryProvider = FutureProvider<List<AttendanceModel>>((
  ref,
) async {
  return ref.read(attendanceRepositoryProvider).getAttendanceHistory();
});

/// Present Days This Month
final presentDaysProvider = FutureProvider<int>((ref) async {
  return ref.read(attendanceRepositoryProvider).getPresentDaysThisMonth();
});

/// Check In Provider
final checkInProvider = Provider((ref) {
  return () async {
    await ref.read(attendanceRepositoryProvider).checkIn();

    ref.invalidate(attendanceProvider);
    ref.invalidate(attendanceHistoryProvider);
    ref.invalidate(presentDaysProvider);
  };
});

/// Check Out Provider
final checkOutProvider = Provider((ref) {
  return () async {
    await ref.read(attendanceRepositoryProvider).checkOut();

    ref.invalidate(attendanceProvider);
    ref.invalidate(attendanceHistoryProvider);
    ref.invalidate(presentDaysProvider);
  };
});
