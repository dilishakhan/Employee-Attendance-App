import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/leave_model.dart';

class LeaveTile extends StatelessWidget {
  final LeaveModel leave;

  const LeaveTile({super.key, required this.leave});

  Color getStatusColor() {
    switch (leave.status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  leave.leaveType,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),

                Chip(
                  label: Text(leave.status),
                  backgroundColor: getStatusColor().withOpacity(.2),
                  labelStyle: TextStyle(
                    color: getStatusColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text("From: ${DateFormat('dd MMM yyyy').format(leave.startDate)}"),

            Text("To: ${DateFormat('dd MMM yyyy').format(leave.endDate)}"),

            const SizedBox(height: 10),

            const Text("Reason", style: TextStyle(fontWeight: FontWeight.bold)),

            Text(leave.reason),
          ],
        ),
      ),
    );
  }
}
