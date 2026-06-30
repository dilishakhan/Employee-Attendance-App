import 'package:employee_attendance_app/features/leave/providers/leave_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveRequestScreen extends ConsumerStatefulWidget {
  const LeaveRequestScreen({super.key});

  @override
  ConsumerState<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends ConsumerState<LeaveRequestScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _reasonController = TextEditingController();

  String? _leaveType;

  DateTime? _startDate;
  DateTime? _endDate;

  bool _isLoading = false;

  final List<String> leaveTypes = [
    "Sick Leave",
    "Casual Leave",
    "Annual Leave",
    "Emergency Leave",
  ];

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;

        if (_endDate != null && _endDate!.isBefore(_startDate!)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> pickEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Select start date first")));
      return;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate!,
      firstDate: _startDate!,
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> submitLeave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select dates")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(submitLeaveProvider)(
        leaveType: _leaveType!,
        startDate: _startDate!,
        endDate: _endDate!,
        reason: _reasonController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Leave Request Submitted")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Leave")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              DropdownButtonFormField<String>(
                value: _leaveType,

                decoration: const InputDecoration(
                  labelText: "Leave Type",
                  border: OutlineInputBorder(),
                ),

                items: leaveTypes
                    .map(
                      (type) =>
                          DropdownMenuItem(value: type, child: Text(type)),
                    )
                    .toList(),

                onChanged: (value) {
                  setState(() {
                    _leaveType = value;
                  });
                },

                validator: (value) {
                  if (value == null) {
                    return "Select Leave Type";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              ListTile(
                tileColor: Colors.grey.shade100,

                title: Text(
                  _startDate == null
                      ? "Select Start Date"
                      : _startDate!.toString().split(" ")[0],
                ),

                trailing: const Icon(Icons.calendar_today),

                onTap: pickStartDate,
              ),

              const SizedBox(height: 20),

              ListTile(
                tileColor: Colors.grey.shade100,

                title: Text(
                  _endDate == null
                      ? "Select End Date"
                      : _endDate!.toString().split(" ")[0],
                ),

                trailing: const Icon(Icons.calendar_today),

                onTap: pickEndDate,
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _reasonController,

                maxLines: 4,

                decoration: const InputDecoration(
                  labelText: "Reason",
                  border: OutlineInputBorder(),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Reason is required";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton(
                  onPressed: _isLoading ? null : submitLeave,

                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Submit Leave"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
