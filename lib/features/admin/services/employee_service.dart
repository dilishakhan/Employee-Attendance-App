import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/employee_model.dart';

class EmployeeService {
  final _client = Supabase.instance.client;

  Future<List<EmployeeModel>> getEmployees() async {
    final response = await _client.from('users').select().order('name');

    return response
        .map<EmployeeModel>((e) => EmployeeModel.fromJson(e))
        .toList();
  }
}
