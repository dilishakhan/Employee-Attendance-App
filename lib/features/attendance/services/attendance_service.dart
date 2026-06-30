import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/attendance_model.dart';

class AttendanceService {
  final SupabaseClient _client = Supabase.instance.client;

  /// Get today's attendance
  Future<AttendanceModel?> getTodayAttendance() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await _client
        .from('attendance')
        .select()
        .eq('user_id', user.id)
        .eq('date', today)
        .maybeSingle();

    if (response == null) return null;

    return AttendanceModel.fromJson(response);
  }

  /// CHECK IN (UTC FIXED)
  Future<void> checkIn() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final today = DateTime.now().toIso8601String().split('T').first;

    final existing = await _client
        .from('attendance')
        .select()
        .eq('user_id', user.id)
        .eq('date', today)
        .maybeSingle();

    if (existing != null) {
      throw Exception("Already checked in today.");
    }

    await _client.from('attendance').insert({
      'user_id': user.id,
      'date': today,
      'check_in': DateTime.now().toUtc().toIso8601String(),
    });
  }

  /// CHECK OUT (UTC FIXED + SAFE CALCULATION)
  Future<void> checkOut() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final attendance = await getTodayAttendance();

    if (attendance == null) {
      throw Exception("No check-in found.");
    }

    if (attendance.checkOut != null) {
      throw Exception("Already checked out.");
    }

    final now = DateTime.now().toUtc();
    final checkIn = attendance.checkIn.toUtc();

    final duration = now.difference(checkIn);

    // Safety: prevent negative values
    final hours = duration.isNegative ? 0.0 : duration.inMinutes / 60.0;

    await _client
        .from('attendance')
        .update({'check_out': now.toIso8601String(), 'total_hours': hours})
        .eq('id', attendance.id);
  }
}
