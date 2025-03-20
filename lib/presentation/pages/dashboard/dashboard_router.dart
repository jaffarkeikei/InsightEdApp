import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insighted/core/constants/route_constants.dart';
import 'package:insighted/presentation/pages/dashboard/admin_dashboard_page.dart';
import 'package:insighted/presentation/pages/dashboard/student_dashboard_page.dart';
import 'package:insighted/presentation/pages/dashboard/teacher_dashboard_page.dart';

class DashboardRouter {
  static GoRoute dashboardRoutes() {
    return GoRoute(
      path: RouteConstants.dashboard,
      builder: (BuildContext context, GoRouterState state) {
        // Determine user role and direct to appropriate dashboard
        // This would typically be determined from authenticated user state
        final userRole = state.extra as String? ?? 'student';

        switch (userRole) {
          case 'admin':
            return const AdminDashboardPage();
          case 'teacher':
            return const TeacherDashboardPage();
          case 'student':
          default:
            return const StudentDashboardPage();
        }
      },
      routes: [
        GoRoute(
          path: 'admin',
          builder: (BuildContext context, GoRouterState state) {
            return const AdminDashboardPage();
          },
        ),
        GoRoute(
          path: 'teacher',
          builder: (BuildContext context, GoRouterState state) {
            return const TeacherDashboardPage();
          },
        ),
        GoRoute(
          path: 'student',
          builder: (BuildContext context, GoRouterState state) {
            return const StudentDashboardPage();
          },
        ),
      ],
    );
  }
}
