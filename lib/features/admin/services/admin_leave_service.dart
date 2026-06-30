import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/admin_leave_model.dart';

class AdminLeaveService {
  final _client = Supabase.instance.client;

  Future<List<AdminLeaveModel>> getPendingLeaves() async {
    final response = await _client
        .from('leave_requests')
        .select('*, users(name)')
        .eq('status', 'Pending')
        .order('created_at', ascending: false);

    return response
        .map<AdminLeaveModel>((e) => AdminLeaveModel.fromJson(e))
        .toList();
  }

  Future<void> approveLeave(String id) async {
    await _client
        .from('leave_requests')
        .update({'status': 'Approved'})
        .eq('id', id);
  }

  Future<void> rejectLeave(String id) async {
    await _client
        .from('leave_requests')
        .update({'status': 'Rejected'})
        .eq('id', id);
  }
}
