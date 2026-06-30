import 'package:employee_attendance_app/core/constants/supabase_constants.dart';
import 'package:employee_attendance_app/features/auth/screens/login_screen.dart';
import 'package:employee_attendance_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConstants.supabaseUrl,
    anonKey: SupabaseConstants.supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    print("CURRENT USER: ${user?.email}");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Attendance',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: user == null ? const LoginScreen() : const DashboardScreen(),
    );
  }
}
