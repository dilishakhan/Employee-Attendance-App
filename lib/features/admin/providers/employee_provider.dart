import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/employee_model.dart';
import '../services/employee_service.dart';

final employeeServiceProvider = Provider((ref) => EmployeeService());

final employeeProvider = FutureProvider<List<EmployeeModel>>((ref) async {
  return ref.read(employeeServiceProvider).getEmployees();
});
