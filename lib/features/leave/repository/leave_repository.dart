import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/leave_model.dart';

class LeaveRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> submitLeave({
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    await _client.from('leave_requests').insert({
      'user_id': user.id,
      'leave_type': leaveType,
      'start_date': startDate.toIso8601String().split('T').first,
      'end_date': endDate.toIso8601String().split('T').first,
      'reason': reason,
      'status': 'Pending',
    });
  }

  Future<List<LeaveModel>> getLeaveHistory() async {
    final user = _client.auth.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    final response = await _client
        .from('leave_requests')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response
        .map<LeaveModel>((json) => LeaveModel.fromJson(json))
        .toList();
  }

  Future<int> getTotalLeaves() async {
    final history = await getLeaveHistory();
    return history.length;
  }

  Future<int> getPendingLeaves() async {
    final history = await getLeaveHistory();

    return history.where((leave) => leave.status == "Pending").length;
  }

  Future<int> getApprovedLeaves() async {
    final history = await getLeaveHistory();

    return history.where((leave) => leave.status == "Approved").length;
  }
}
