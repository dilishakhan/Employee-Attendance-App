/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/admin_card.dart';

import '../providers/admin_provider.dart';

import 'employee_list_screen.dart';
import 'leave_requests_screen.dart';
import 'attendance_overview_screen.dart';

import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeCount = ref.watch(employeeCountProvider);
    final leaveCount = ref.watch(pendingLeaveProvider);
    final attendanceCount = ref.watch(attendanceCountProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(employeeCountProvider);
            ref.invalidate(pendingLeaveProvider);
            ref.invalidate(attendanceCountProvider);
          },

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff2563EB), Color(0xff3B82F6)],
                    ),

                    borderRadius: BorderRadius.circular(24),
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Icon(
                        Icons.admin_panel_settings,
                        color: Colors.white,
                        size: 42,
                      ),

                      const SizedBox(height: 20),

                      Text(
                        "Welcome Admin 👋",
                        style: AppTextStyles.heading.copyWith(
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "Manage employees and monitor attendance.",
                        style: AppTextStyles.subtitle.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.25,

                  children: [
                    employeeCount.when(
                      data: (count) => AdminCard(
                        icon: Icons.people_alt_rounded,
                        title: "$count Employees",
                        subtitle: "Manage Staff",
                        color: AppColors.primary,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EmployeeListScreen(),
                            ),
                          );
                        },
                      ),

                      loading: () => const _LoadingCard(),

                      error: (_, __) => AdminCard(
                        icon: Icons.people_alt_rounded,
                        title: "--",
                        subtitle: "Employees",
                        color: AppColors.primary,
                        onTap: () {},
                      ),
                    ),

                    leaveCount.when(
                      data: (count) => AdminCard(
                        icon: Icons.event_note_rounded,
                        title: "$count Pending",
                        subtitle: "Leave Requests",
                        color: Colors.orange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LeaveRequestsScreen(),
                            ),
                          );
                        },
                      ),

                      loading: () => const _LoadingCard(),

                      error: (_, __) => AdminCard(
                        icon: Icons.event_note_rounded,
                        title: "--",
                        subtitle: "Leave Requests",
                        color: Colors.orange,
                        onTap: () {},
                      ),
                    ),

                    attendanceCount.when(
                      data: (count) => AdminCard(
                        icon: Icons.access_time_filled_rounded,
                        title: "$count Today",
                        subtitle: "Attendance",
                        color: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const AttendanceOverviewScreen(),
                            ),
                          );
                        },
                      ),

                      loading: () => const _LoadingCard(),

                      error: (_, __) => AdminCard(
                        icon: Icons.access_time_filled_rounded,
                        title: "--",
                        subtitle: "Attendance",
                        color: Colors.green,
                        onTap: () {},
                      ),
                    ),

                    AdminCard(
                      icon: Icons.logout_rounded,
                      title: "Logout",
                      subtitle: "Sign out",
                      color: Colors.red,

                      onTap: () async {
                        await AuthService().logout();

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 35),

                Text("Quick Actions", style: AppTextStyles.title),

                const SizedBox(height: 15),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    children: const [
                      ListTile(
                        leading: Icon(Icons.people, color: AppColors.primary),
                        title: Text("Manage Employees"),
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(
                          Icons.assignment_turned_in,
                          color: Colors.orange,
                        ),
                        title: Text("Approve Leave Requests"),
                      ),

                      Divider(),

                      ListTile(
                        leading: Icon(Icons.analytics, color: Colors.green),
                        title: Text("Attendance Overview"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 10),
        ],
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

import 'package:employee_attendance_app/core/theme/app_colors.dart';
import 'package:employee_attendance_app/core/theme/app_text_styles.dart';
import 'package:employee_attendance_app/features/admin/providers/admin_provider.dart';
import 'package:employee_attendance_app/features/admin/screens/attendance_overview_screen.dart';
import 'package:employee_attendance_app/features/admin/screens/employee_list_screen.dart';
import 'package:employee_attendance_app/features/admin/screens/leave_requests_screen.dart';
import 'package:employee_attendance_app/features/auth/screens/login_screen.dart';
import 'package:employee_attendance_app/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeCount = ref.watch(employeeCountProvider);
    final leaveCount = ref.watch(pendingLeaveProvider);
    final attendanceCount = ref.watch(attendanceCountProvider);

    final width = MediaQuery.of(context).size.width;
    final isDesktop = width > 900;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(employeeCountProvider);
            ref.invalidate(pendingLeaveProvider);
            ref.invalidate(attendanceCountProvider);
          },

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1400),

                child: Padding(
                  padding: const EdgeInsets.all(30),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 28,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xff2563EB), Color(0xff3B82F6)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Good Morning 👋",
                                    style: AppTextStyles.subtitle.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Admin Dashboard",
                                    style: AppTextStyles.heading.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "Manage employees, attendance and leave requests.",
                                    style: AppTextStyles.subtitle.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.admin_panel_settings_rounded,
                                color: Colors.white,
                                size: 38,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                      Text("Overview", style: AppTextStyles.title),

                      const SizedBox(height: 18),

                      Wrap(
                        spacing: 20,
                        runSpacing: 20,

                        children: [
                          SizedBox(
                            width: isDesktop
                                ? (width - 160) / 4
                                : (width - 100) / 2,

                            child: employeeCount.when(
                              data: (count) => _DashboardCard(
                                title: "Employees",
                                value: "$count",
                                subtitle: "Registered",
                                icon: Icons.people_alt_rounded,
                                color: Colors.blue,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const EmployeeListScreen(),
                                    ),
                                  );
                                },
                              ),

                              loading: () => const _LoadingDashboardCard(),

                              error: (_, __) => const _LoadingDashboardCard(),
                            ),
                          ),

                          SizedBox(
                            width: isDesktop
                                ? (width - 160) / 4
                                : (width - 100) / 2,

                            child: leaveCount.when(
                              data: (count) => _DashboardCard(
                                title: "Leave Requests",
                                value: "$count",
                                subtitle: "Pending",
                                icon: Icons.event_note_rounded,
                                color: Colors.orange,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const LeaveRequestsScreen(),
                                    ),
                                  );
                                },
                              ),

                              loading: () => const _LoadingDashboardCard(),

                              error: (_, __) => const _LoadingDashboardCard(),
                            ),
                          ),

                          SizedBox(
                            width: isDesktop
                                ? (width - 160) / 4
                                : (width - 100) / 2,

                            child: attendanceCount.when(
                              data: (count) => _DashboardCard(
                                title: "Attendance",
                                value: "$count",
                                subtitle: "Today",
                                icon: Icons.access_time_filled_rounded,
                                color: Colors.green,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const AttendanceOverviewScreen(),
                                    ),
                                  );
                                },
                              ),

                              loading: () => const _LoadingDashboardCard(),

                              error: (_, __) => const _LoadingDashboardCard(),
                            ),
                          ),

                          SizedBox(
                            width: isDesktop
                                ? (width - 160) / 4
                                : (width - 100) / 2,

                            child: _DashboardCard(
                              title: "Logout",
                              value: "",
                              subtitle: "Sign Out",
                              icon: Icons.logout_rounded,
                              color: Colors.red,

                              onTap: () async {
                                await AuthService().logout();

                                if (!context.mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                  (route) => false,
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 35),
                      Text("Quick Actions", style: AppTextStyles.title),

                      const SizedBox(height: 18),

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.05),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),

                        child: Column(
                          children: [
                            _QuickActionTile(
                              icon: Icons.people_alt_rounded,
                              color: Colors.blue,
                              title: "Manage Employees",
                              subtitle: "View all employees",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EmployeeListScreen(),
                                  ),
                                );
                              },
                            ),

                            const Divider(height: 1),

                            _QuickActionTile(
                              icon: Icons.event_note_rounded,
                              color: Colors.orange,
                              title: "Leave Requests",
                              subtitle: "Approve or reject leave",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LeaveRequestsScreen(),
                                  ),
                                );
                              },
                            ),

                            const Divider(height: 1),

                            _QuickActionTile(
                              icon: Icons.access_time_filled_rounded,
                              color: Colors.green,
                              title: "Attendance Overview",
                              subtitle: "View attendance records",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AttendanceOverviewScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 180,
        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: color.withOpacity(.12),
                  child: Icon(icon, color: color),
                ),

                const Spacer(),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),

            const Spacer(),

            Text(
              value,
              style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 4),

            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class _LoadingDashboardCard extends StatelessWidget {
  const _LoadingDashboardCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(.12),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18),
      onTap: onTap,
    );
  }
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

import '../../auth/screens/login_screen.dart';
import '../../auth/services/auth_service.dart';

import '../providers/admin_provider.dart';

import 'attendance_overview_screen.dart';
import 'employee_list_screen.dart';
import 'leave_requests_screen.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employeeCount = ref.watch(employeeCountProvider);
    final leaveCount = ref.watch(pendingLeaveProvider);
    final attendanceCount = ref.watch(attendanceCountProvider);

    final width = MediaQuery.of(context).size.width;

    final crossAxisCount = width > 900 ? 4 : 2;

    return Scaffold(
      backgroundColor: const Color(0xffF4F7FC),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(employeeCountProvider);

            ref.invalidate(pendingLeaveProvider);

            ref.invalidate(attendanceCountProvider);
          },

          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),

            padding: const EdgeInsets.all(30),

            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1450),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 35,
                        vertical: 30,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Employee Attendance System",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Welcome Back, Admin 👋",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Monitor attendance, manage employees, and approve leave requests from one place.",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.15),
                              borderRadius: BorderRadius.circular(22),
                            ),
                            child: const Icon(
                              Icons.dashboard_customize_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),
                    Text("Overview", style: AppTextStyles.title),

                    const SizedBox(height: 20),

                    GridView.count(
                      crossAxisCount: crossAxisCount,

                      crossAxisSpacing: 20,

                      mainAxisSpacing: 20,

                      shrinkWrap: true,

                      physics: const NeverScrollableScrollPhysics(),

                      childAspectRatio: 1.25,

                      children: [
                        employeeCount.when(
                          data: (value) => DashboardCard(
                            title: "Employees",

                            value: value.toString(),

                            subtitle: "Registered Employees",

                            color: Colors.blue,

                            icon: Icons.people,

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const EmployeeListScreen(),
                                ),
                              );
                            },
                          ),

                          loading: () => const LoadingCard(),

                          error: (_, __) => const LoadingCard(),
                        ),

                        leaveCount.when(
                          data: (value) => DashboardCard(
                            title: "Leave",

                            value: value.toString(),

                            subtitle: "Pending Requests",

                            color: Colors.orange,

                            icon: Icons.assignment,

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) => const LeaveRequestsScreen(),
                                ),
                              );
                            },
                          ),

                          loading: () => const LoadingCard(),

                          error: (_, __) => const LoadingCard(),
                        ),

                        attendanceCount.when(
                          data: (value) => DashboardCard(
                            title: "Attendance",

                            value: value.toString(),

                            subtitle: "Today's Check-ins",

                            color: Colors.green,

                            icon: Icons.access_time,

                            onTap: () {
                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      const AttendanceOverviewScreen(),
                                ),
                              );
                            },
                          ),

                          loading: () => const LoadingCard(),

                          error: (_, __) => const LoadingCard(),
                        ),

                        DashboardCard(
                          title: "Logout",

                          value: "",

                          subtitle: "Secure Logout",

                          color: Colors.red,

                          icon: Icons.logout,

                          onTap: () async {
                            await AuthService().logout();

                            if (!context.mounted) return;

                            Navigator.pushAndRemoveUntil(
                              context,

                              MaterialPageRoute(
                                builder: (_) => const LoginScreen(),
                              ),

                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),
                    Text("Quick Actions", style: AppTextStyles.title),

                    const SizedBox(height: 20),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final desktop = constraints.maxWidth > 900;

                        return GridView.count(
                          crossAxisCount: desktop ? 3 : 1,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: desktop ? 3.5 : 4.5,

                          children: [
                            _QuickAction(
                              icon: Icons.people_alt_rounded,
                              color: Colors.blue,
                              title: "Employees",
                              subtitle: "Manage Employees",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const EmployeeListScreen(),
                                  ),
                                );
                              },
                            ),

                            _QuickAction(
                              icon: Icons.event_note_rounded,
                              color: Colors.orange,
                              title: "Leave Requests",
                              subtitle: "Approve or Reject",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LeaveRequestsScreen(),
                                  ),
                                );
                              },
                            ),

                            _QuickAction(
                              icon: Icons.access_time_filled_rounded,
                              color: Colors.green,
                              title: "Attendance",
                              subtitle: "View Attendance",
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const AttendanceOverviewScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 40),

                    Text("Recent Activity", style: AppTextStyles.title),

                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.05),
                            blurRadius: 15,
                          ),
                        ],
                      ),

                      child: Column(
                        children: const [
                          _ActivityTile(
                            icon: Icons.login,
                            color: Colors.green,
                            title: "Employees checked in today",
                            subtitle: "Live attendance updates",
                          ),

                          Divider(height: 1),

                          _ActivityTile(
                            icon: Icons.pending_actions,
                            color: Colors.orange,
                            title: "Pending leave requests",
                            subtitle: "Waiting for approval",
                          ),

                          Divider(height: 1),

                          _ActivityTile(
                            icon: Icons.groups,
                            color: Colors.blue,
                            title: "Employee directory",
                            subtitle: "Manage all employees",
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),

      onTap: onTap,

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),

        padding: const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(24),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withOpacity(.12),
                  child: Icon(icon, color: color, size: 26),
                ),

                const Spacer(),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),

            const Spacer(),

            if (value.isNotEmpty)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                ),
              ),

            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),

            const SizedBox(height: 6),

            Text(subtitle, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Center(
        child: SizedBox(
          height: 35,
          width: 35,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,

        child: Ink(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: color.withOpacity(.12),
                  child: Icon(icon, color: color),
                ),

                const SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        subtitle,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _ActivityTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),

      leading: CircleAvatar(
        radius: 22,
        backgroundColor: color.withOpacity(.12),
        child: Icon(icon, color: color),
      ),

      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),

      subtitle: Text(subtitle),

      trailing: const Icon(Icons.chevron_right),
    );
  }
}
