import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../models/admin_attendance_model.dart';
import '../providers/admin_attendance_provider.dart';

class AttendanceOverviewScreen extends ConsumerStatefulWidget {
  const AttendanceOverviewScreen({super.key});

  @override
  ConsumerState<AttendanceOverviewScreen> createState() =>
      _AttendanceOverviewScreenState();
}

class _AttendanceOverviewScreenState
    extends ConsumerState<AttendanceOverviewScreen> {
  final TextEditingController _searchController = TextEditingController();

  String search = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendance = ref.watch(attendanceOverviewProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: false,
        title: const Text(
          "Attendance Overview",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: TextField(
                controller: _searchController,

                onChanged: (value) {
                  setState(() {
                    search = value.toLowerCase();
                  });
                },

                decoration: const InputDecoration(
                  hintText: "Search employee...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: attendance.when(
                data: (list) {
                  final filtered = list.where((employee) {
                    return employee.employeeName.toLowerCase().contains(search);
                  }).toList();

                  if (filtered.isEmpty) {
                    return const Center(
                      child: Text(
                        "No Attendance Records Found",
                        style: TextStyle(fontSize: 18),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return AttendanceCard(attendance: filtered[index]);
                    },
                  );
                },

                loading: () => const Center(child: CircularProgressIndicator()),

                error: (e, _) => Center(child: Text(e.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final AdminAttendanceModel attendance;

  const AttendanceCard({super.key, required this.attendance});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 18),

      elevation: 2,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),

      child: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.blue.shade100,

                  child: Text(
                    attendance.employeeName.substring(0, 1).toUpperCase(),

                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        attendance.employeeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        DateFormat('dd MMM yyyy').format(attendance.date),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const Divider(height: 35),

            _infoRow(
              Icons.login,
              "Check In",
              DateFormat('hh:mm a').format(attendance.checkIn),
            ),

            const SizedBox(height: 12),

            _infoRow(
              Icons.logout,
              "Check Out",
              attendance.checkOut == null
                  ? "Not Checked Out"
                  : DateFormat('hh:mm a').format(attendance.checkOut!),
            ),

            const SizedBox(height: 12),

            _infoRow(
              Icons.schedule,
              "Working Hours",
              "${attendance.totalHours.toStringAsFixed(2)} hrs",
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),

        const SizedBox(width: 12),

        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        const Spacer(),

        Text(value),
      ],
    );
  }
}
