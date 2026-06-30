import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/admin_attendance_model.dart';

class AdminAttendanceService {
  final _client = Supabase.instance.client;

  Future<List<AdminAttendanceModel>> getAttendance() async {
    final response = await _client
        .from('attendance')
        .select('*, users(name)')
        .order('date', ascending: false);

    return response
        .map<AdminAttendanceModel>((e) => AdminAttendanceModel.fromJson(e))
        .toList();
  }
}
