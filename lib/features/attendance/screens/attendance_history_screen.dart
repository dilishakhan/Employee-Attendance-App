import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/attendance_provider.dart';
import '../widgets/attendance_tile.dart';

class AttendanceHistoryScreen extends ConsumerStatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  ConsumerState<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState
    extends ConsumerState<AttendanceHistoryScreen> {
  DateTime? selectedDate;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final attendanceHistory = ref.watch(attendanceHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickDate(context),
                    icon: const Icon(Icons.calendar_today),
                    label: Text(
                      selectedDate == null
                          ? "Filter by Date"
                          : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                    ),
                  ),
                ),

                if (selectedDate != null) ...[
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        selectedDate = null;
                      });
                    },
                    icon: const Icon(Icons.clear),
                    tooltip: "Clear Filter",
                  ),
                ],
              ],
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(attendanceHistoryProvider);
                await ref.read(attendanceHistoryProvider.future);
              },

              child: attendanceHistory.when(
                loading: () => const Center(child: CircularProgressIndicator()),

                error: (error, stackTrace) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),

                        const SizedBox(height: 15),

                        const Text(
                          "Failed to load attendance history.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(error.toString(), textAlign: TextAlign.center),

                        const SizedBox(height: 20),

                        ElevatedButton.icon(
                          onPressed: () {
                            ref.invalidate(attendanceHistoryProvider);
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),

                data: (records) {
                  final filteredRecords = selectedDate == null
                      ? records
                      : records.where((record) {
                          final date = record.date;

                          return date.year == selectedDate!.year &&
                              date.month == selectedDate!.month &&
                              date.day == selectedDate!.day;
                        }).toList();

                  if (filteredRecords.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        const SizedBox(height: 180),
                        const Icon(
                          Icons.calendar_month,
                          size: 70,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            selectedDate == null
                                ? "No attendance records found."
                                : "No attendance found for the selected date.",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Center(
                          child: Text(
                            "Pull down to refresh or clear the filter.",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      return AttendanceTile(record: filteredRecords[index]);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
