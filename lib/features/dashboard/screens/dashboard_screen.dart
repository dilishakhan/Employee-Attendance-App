import 'package:employee_attendance_app/features/attendance/providers/attendance_provider.dart';
import 'package:employee_attendance_app/features/attendance/screens/attendance_history_screen.dart';
import 'package:employee_attendance_app/features/auth/screens/login_screen.dart';
import 'package:employee_attendance_app/features/auth/services/auth_service.dart';
import 'package:employee_attendance_app/features/profile/providers/profile_provider.dart';
import 'package:employee_attendance_app/features/leave/providers/leave_provider.dart';
import 'package:employee_attendance_app/features/leave/screens/leave_history_screen.dart';
import 'package:employee_attendance_app/features/leave/screens/leave_request_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  Future<void> logout(BuildContext context) async {
    await AuthService().logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileProvider);
    final attendance = ref.watch(attendanceProvider);
    final presentDays = ref.watch(presentDaysProvider);

    final totalLeaves = ref.watch(totalLeavesProvider);
    final pendingLeaves = ref.watch(pendingLeavesProvider);
    final approvedLeaves = ref.watch(approvedLeavesProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Employee Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: user.when(
        loading: () => const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),

        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  "Good Morning 👋",
                  style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                ),

                const SizedBox(height: 8),

                Text(
                  profile.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const CircleAvatar(
                            radius: 28,
                            child: Icon(Icons.person),
                          ),
                          title: Text(
                            profile.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(profile.email),
                        ),

                        const Divider(),

                        ListTile(
                          leading: const Icon(Icons.business),
                          title: const Text("Department"),
                          subtitle: Text(profile.department),
                        ),

                        ListTile(
                          leading: const Icon(Icons.badge),
                          title: const Text("Role"),
                          subtitle: Text(profile.role),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                attendance.when(
                  loading: () => const Card(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),

                  error: (e, _) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(e.toString()),
                    ),
                  ),

                  data: (record) {
                    final checkedIn = record != null;
                    final checkedOut = record?.checkOut != null;

                    String workingHoursText = "0h 0m";

                    if (record != null && record.checkOut != null) {
                      final duration = record.checkOut!.difference(
                        record.checkIn,
                      );

                      final hours = duration.inHours;
                      final minutes = duration.inMinutes % 60;

                      workingHoursText = "${hours}h ${minutes}m";
                    }

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Today's Attendance",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),

                            const SizedBox(height: 20),

                            /// Status
                            Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 12,
                                  color: checkedOut
                                      ? Colors.blue
                                      : checkedIn
                                      ? Colors.green
                                      : Colors.red,
                                ),

                                const SizedBox(width: 10),

                                Text(
                                  checkedOut
                                      ? "Checked Out"
                                      : checkedIn
                                      ? "Checked In"
                                      : "Not Checked In",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            if (checkedIn)
                              Text(
                                "Check In : ${TimeOfDay.fromDateTime(record!.checkIn.toLocal()).format(context)}",
                              ),

                            if (checkedOut) ...[
                              const SizedBox(height: 10),

                              Text(
                                "Check Out : ${TimeOfDay.fromDateTime(record!.checkOut!.toLocal()).format(context)}",
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Working Hours : $workingHoursText",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],

                            const SizedBox(height: 15),

                            presentDays.when(
                              loading: () => const CircularProgressIndicator(),

                              error: (_, __) => const Text("Present Days : --"),

                              data: (days) => Text(
                                "Present This Month : $days",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                icon: Icon(
                                  checkedIn && !checkedOut
                                      ? Icons.logout
                                      : Icons.login,
                                ),
                                label: Text(
                                  checkedIn
                                      ? (checkedOut ? "Completed" : "Check Out")
                                      : "Check In",
                                ),
                                onPressed: checkedOut
                                    ? null
                                    : () async {
                                        try {
                                          if (!checkedIn) {
                                            await ref.read(checkInProvider)();
                                          } else {
                                            await ref.read(checkOutProvider)();
                                          }

                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  !checkedIn
                                                      ? "Checked In Successfully"
                                                      : "Checked Out Successfully",
                                                ),
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                              ),
                                            );
                                          }
                                        }
                                      },
                              ),
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton.icon(
                                icon: const Icon(Icons.history),
                                label: const Text("Attendance History"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AttendanceHistoryScreen(),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 25),

                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Leave Summary",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        totalLeaves.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const Text("Total Requests : --"),
                          data: (count) => Text(
                            "Total Requests : $count",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 10),

                        pendingLeaves.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const Text("Pending Requests : --"),
                          data: (count) => Text(
                            "Pending Requests : $count",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 10),

                        approvedLeaves.when(
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) =>
                              const Text("Approved Requests : --"),
                          data: (count) => Text(
                            "Approved Requests : $count",
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.event_available),
                            label: const Text("Request Leave"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LeaveRequestScreen(),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.history),
                            label: const Text("Leave History"),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LeaveHistoryScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
