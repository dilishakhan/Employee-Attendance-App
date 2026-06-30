import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_leave_model.dart';
import '../providers/admin_leave_provider.dart';
import '../services/admin_leave_service.dart';

class LeaveRequestsScreen extends ConsumerWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaveRequests = ref.watch(pendingLeaveProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        title: const Text("Leave Requests"),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: leaveRequests.when(
          data: (leaves) {
            if (leaves.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event_busy, size: 80, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      "No Pending Leave Requests",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: leaves.length,
              itemBuilder: (context, index) {
                return LeaveCard(leave: leaves[index]);
              },
            );
          },

          loading: () => const Center(child: CircularProgressIndicator()),

          error: (error, stack) => Center(child: Text(error.toString())),
        ),
      ),
    );
  }
}

class LeaveCard extends ConsumerWidget {
  final AdminLeaveModel leave;

  const LeaveCard({super.key, required this.leave});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 20),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Padding(
        padding: const EdgeInsets.all(22),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.orange.withOpacity(.15),
                  child: const Icon(Icons.person, color: Colors.orange),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        leave.employeeName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        leave.leaveType,
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 35),

            Row(
              children: [
                const Icon(Icons.calendar_month, size: 20, color: Colors.blue),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "From: ${leave.startDate.day}/${leave.startDate.month}/${leave.startDate.year}",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                const Icon(Icons.calendar_today, size: 20, color: Colors.green),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    "To: ${leave.endDate.day}/${leave.endDate.month}/${leave.endDate.year}",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            const Text("Reason", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Text(leave.reason, style: TextStyle(color: Colors.grey.shade700)),

            const SizedBox(height: 25),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),

                    onPressed: () async {
                      await ref
                          .read(adminLeaveServiceProvider)
                          .approveLeave(leave.id);

                      ref.invalidate(pendingLeaveProvider);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Leave Approved")),
                        );
                      }
                    },

                    icon: const Icon(Icons.check),

                    label: const Text("Approve"),
                  ),
                ),

                const SizedBox(width: 15),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),

                    onPressed: () async {
                      await ref
                          .read(adminLeaveServiceProvider)
                          .rejectLeave(leave.id);

                      ref.invalidate(pendingLeaveProvider);

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Leave Rejected")),
                        );
                      }
                    },

                    icon: const Icon(Icons.close),

                    label: const Text("Reject"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
