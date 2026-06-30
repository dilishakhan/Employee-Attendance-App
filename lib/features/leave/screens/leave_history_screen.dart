import 'package:employee_attendance_app/features/leave/providers/leave_provider.dart';
import 'package:employee_attendance_app/features/leave/widgets/leave_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveHistoryScreen extends ConsumerWidget {
  const LeaveHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaves = ref.watch(leaveHistoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Leave History")),

      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(leaveHistoryProvider);
          await ref.read(leaveHistoryProvider.future);
        },

        child: leaves.when(
          loading: () => const Center(child: CircularProgressIndicator()),

          error: (e, _) => Center(child: Text(e.toString())),

          data: (records) {
            if (records.isEmpty) {
              return ListView(
                children: const [
                  SizedBox(height: 180),

                  Icon(Icons.event_busy, size: 70, color: Colors.grey),

                  SizedBox(height: 20),

                  Center(
                    child: Text(
                      "No Leave Requests",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }

            return ListView.builder(
              itemCount: records.length,
              itemBuilder: (_, index) {
                return LeaveTile(leave: records[index]);
              },
            );
          },
        ),
      ),
    );
  }
}
