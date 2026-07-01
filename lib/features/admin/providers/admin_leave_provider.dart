import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_leave_model.dart';
import '../services/admin_leave_service.dart';

final adminLeaveServiceProvider = Provider((ref) => AdminLeaveService());

final pendingLeaveProvider = FutureProvider<List<AdminLeaveModel>>((ref) async {
  return ref.read(adminLeaveServiceProvider).getPendingLeaves();
});

final allLeaveProvider = FutureProvider<List<AdminLeaveModel>>((ref) async {
  return ref.read(adminLeaveServiceProvider).getAllLeaves();
});
