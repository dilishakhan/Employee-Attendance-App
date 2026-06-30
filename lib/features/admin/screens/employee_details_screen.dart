import 'package:flutter/material.dart';

import '../models/employee_model.dart';

class EmployeeDetailsScreen extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeDetailsScreen({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(elevation: 0, title: const Text("Employee Details")),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),

          child: Card(
            margin: const EdgeInsets.all(25),
            elevation: 3,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),

            child: Padding(
              padding: const EdgeInsets.all(30),

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      employee.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    employee.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(employee.email),
                  ),

                  ListTile(
                    leading: const Icon(Icons.business),
                    title: Text(employee.department),
                  ),

                  ListTile(
                    leading: const Icon(Icons.badge),
                    title: Text(employee.role.toUpperCase()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
