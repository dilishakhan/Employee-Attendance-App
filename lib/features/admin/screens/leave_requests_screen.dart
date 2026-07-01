import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/admin_leave_model.dart';
import '../providers/admin_leave_provider.dart';
//import '../services/admin_leave_service.dart';

class LeaveRequestsScreen extends ConsumerStatefulWidget {
  const LeaveRequestsScreen({super.key});

  @override
  ConsumerState<LeaveRequestsScreen> createState() =>
      _LeaveRequestsScreenState();
}

class _LeaveRequestsScreenState extends ConsumerState<LeaveRequestsScreen> {
  String selectedStatus = "All";

  @override
  Widget build(BuildContext context) {
    final leaveRequests = ref.watch(allLeaveProvider);

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
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                labelText: "Filter by Status",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(value: "All", child: Text("All")),
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(value: "Approved", child: Text("Approved")),
                DropdownMenuItem(value: "Rejected", child: Text("Rejected")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedStatus = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            Expanded(
              child: leaveRequests.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (error, stack) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 70,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "Failed to load leave requests",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(error.toString()),
                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: () {
                            ref.invalidate(allLeaveProvider);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                },

                data: (leaves) {
                  final filteredLeaves = selectedStatus == "All"
                      ? leaves
                      : leaves.where((leave) {
                          return leave.status == selectedStatus;
                        }).toList();

                  if (filteredLeaves.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.event_busy, size: 80, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            "No Leave Requests Found",
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
                    itemCount: filteredLeaves.length,
                    itemBuilder: (context, index) {
                      return LeaveCard(leave: filteredLeaves[index]);
                    },
                  );
                },
              ),
            ),
          ],
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
    Color statusColor;

    switch (leave.status) {
      case "Approved":
        statusColor = Colors.green;
        break;
      case "Rejected":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.orange;
    }

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

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    leave.status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 35),

            Row(
              children: [
                const Icon(Icons.calendar_month, color: Colors.blue),
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
                const Icon(Icons.calendar_today, color: Colors.green),
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

            if (leave.status == "Pending") ...[
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
                        ref.invalidate(allLeaveProvider);

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
                        ref.invalidate(allLeaveProvider);

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
          ],
        ),
      ),
    );
  }
}
