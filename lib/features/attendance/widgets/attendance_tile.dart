import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/attendance_model.dart';

class AttendanceTile extends StatelessWidget {
  final AttendanceModel record;

  const AttendanceTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Date
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                Text(
                  DateFormat('dd MMM yyyy').format(record.date),
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const Divider(height: 25),

            /// Check In
            Row(
              children: [
                const Icon(Icons.login, color: Colors.green),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Check In",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                Text(
                  DateFormat('hh:mm a').format(record.checkIn.toLocal()),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Check Out
            Row(
              children: [
                const Icon(Icons.logout, color: Colors.red),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Check Out",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                Text(
                  record.checkOut != null
                      ? DateFormat('hh:mm a').format(record.checkOut!.toLocal())
                      : "--",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// Working Hours
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.orange),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Working Hours",
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
                Text(
                  record.totalHours != null
                      ? "${record.totalHours!.toStringAsFixed(2)} hrs"
                      : "--",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
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
