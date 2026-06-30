import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<int> getEmployeeCount() async {
    final response = await _client
        .from('users')
        .select()
        .eq('role', 'Employee');

    return response.length;
  }

  Future<int> getPendingLeaveCount() async {
    final response = await _client
        .from('leave_requests')
        .select()
        .eq('status', 'Pending');

    return response.length;
  }

  Future<int> getTodayAttendanceCount() async {
    final today = DateTime.now().toIso8601String().split('T').first;

    final response = await _client
        .from('attendance')
        .select()
        .eq('date', today);

    return response.length;
  }
}
