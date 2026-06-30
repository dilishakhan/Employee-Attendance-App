import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/leave_model.dart';
import '../repository/leave_repository.dart';

/// Repository
final leaveRepositoryProvider = Provider<LeaveRepository>((ref) {
  return LeaveRepository();
});

/// Leave History
final leaveHistoryProvider = FutureProvider<List<LeaveModel>>((ref) async {
  return ref.read(leaveRepositoryProvider).getLeaveHistory();
});

/// Total Leaves
final totalLeavesProvider = FutureProvider<int>((ref) async {
  return ref.read(leaveRepositoryProvider).getTotalLeaves();
});

/// Pending Leaves
final pendingLeavesProvider = FutureProvider<int>((ref) async {
  return ref.read(leaveRepositoryProvider).getPendingLeaves();
});

/// Approved Leaves
final approvedLeavesProvider = FutureProvider<int>((ref) async {
  return ref.read(leaveRepositoryProvider).getApprovedLeaves();
});

/// Submit Leave
final submitLeaveProvider = Provider((ref) {
  return ({
    required String leaveType,
    required DateTime startDate,
    required DateTime endDate,
    required String reason,
  }) async {
    await ref
        .read(leaveRepositoryProvider)
        .submitLeave(
          leaveType: leaveType,
          startDate: startDate,
          endDate: endDate,
          reason: reason,
        );

    ref.invalidate(leaveHistoryProvider);
    ref.invalidate(totalLeavesProvider);
    ref.invalidate(pendingLeavesProvider);
    ref.invalidate(approvedLeavesProvider);
  };
});
