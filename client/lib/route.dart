import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:client/services/auth_service.dart';
import 'package:client/models/employee_model.dart';
import 'package:client/widgets/navbar_admin.dart';
import 'package:client/widgets/navbar_user.dart';
import 'package:client/screens/Group_1/home_screen_admin.dart';
import 'package:client/screens/Group_1/home_screen_employee.dart';
import 'package:client/screens/Group_1/Karyawan/employee_izin_form.dart';
import 'package:client/screens/Group_1/Admin/all_letters_page.dart';
import 'package:client/screens/Group_1/Admin/add_template_screen.dart';
import 'package:client/screens/Group_1/Admin/list_template_screen.dart';
import 'package:client/screens/Group_1/Admin/edit_template_screen.dart';
import 'package:client/screens/Group_1/Admin/izin_laporan_menu.dart';
import 'package:client/screens/Group_1/Admin/admin_izin_manager.dart';
import 'package:client/screens/Group_1/Admin/department_detail_page.dart';
import 'package:client/screens/Group_1/Admin/IzinDetailPage.dart';
import 'package:client/screens/groupTwo/edit_admin_employee_screen.dart';
import 'package:client/screens/groupTwo/edit_personal_screen.dart';
import 'package:client/screens/groupTwo/department_crud_screen.dart';
import 'package:client/screens/groupTwo/position_crud_screen.dart';
import 'package:client/screens/employee_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:client/screens/attendance_screen.dart';
import 'package:client/screens/schedule_screen.dart';
import 'package:client/screens/payroll_screen.dart';
import 'package:client/screens/forgot_password_screen.dart';
import 'package:client/screens/profile_screen.dart';
import 'package:client/screens/change_password_screen.dart';
import 'package:client/screens/register_screen.dart';
import 'package:client/screens/placeholder_screen.dart';

final storage = FlutterSecureStorage();

final GoRouter router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    return AuthService.instance.redirectUser(state);
  },
  routes: [
    // ========================================
    // ADMIN SHELL ROUTES
    // ========================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavbarAdmin(navigationShell: navigationShell),
      ),
      branches: [
        // BRANCH 1 – Admin Home + Izin Management (FROM GROUP 1)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/admin",
              name: "home",
              builder: (context, state) => const HomeScreenAdmin(),
            ),

            // Laporan Izin
            GoRoute(
              path: '/laporan-izin',
              name: 'laporan_izin',
              builder: (context, state) => const AdminIzinDashboard(),
            ),

            // Kelola Izin
            GoRoute(
              path: '/kelola-izin',
              name: 'kelola_izin',
              builder: (context, state) => const AdminIzinManager(),
            ),

            // Placeholder Menu
            GoRoute(
              path: '/absensi',
              name: 'absensi',
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Absensi'),
            ),
            GoRoute(
              path: '/karyawan',
              name: 'karyawan',
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Karyawan'),
            ),
            GoRoute(
              path: '/payroll',
              name: 'payroll',
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Payroll'),
            ),
            GoRoute(
              path: '/pengaturan',
              name: 'pengaturan',
              builder: (context, state) =>
                  const PlaceholderScreen(title: 'Pengaturan'),
            ),

            // Letter Management
            GoRoute(
              path: '/admin/all-letters',
              builder: (context, state) {
                final letters = state.extra as List<dynamic>;
                return AllLettersPage(letters: letters);
              },
            ),
            GoRoute(
              path: '/admin/department-detail',
              builder: (context, state) {
                final dept = state.extra as Map<String, dynamic>;
                return DepartmentDetailPage(departmentData: dept);
              },
            ),
            GoRoute(
              path: '/admin/template/add',
              builder: (context, state) => const AddTemplateScreen(),
            ),
            GoRoute(
              path: '/admin/template/list',
              builder: (context, state) => const ListTemplateScreen(),
            ),
            GoRoute(
              path: "/admin/template/edit",
              builder: (context, state) {
                final data = state.extra as Map<String, dynamic>;
                return EditTemplateScreen(template: data);
              },
            ),
          ],
        ),

        // BRANCH 2 – Employee Management & Register
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/admin/employee",
              builder: (context, state) => const EmployeeScreen(),
            ),
            GoRoute(
              path: "/admin/profile-detail",
              builder: (context, state) {
                final userId = state.extra as int?;
                return ProfileScreen(userId: userId);
              },
            ),
            GoRoute(
              path: "/admin/register",
              builder: (context, state) => const RegisterScreen(),
            ),
            GoRoute(
              path: "/admin/edit-employee",
              builder: (context, state) {
                final employeeId = state.extra as int?;
                if (employeeId == null) {
                  return const Scaffold(
                    body: Center(
                      child: Text('Error: ID karyawan tidak ditemukan'),
                    ),
                  );
                }
                return EditAdminEmployeeScreen(employeeId: employeeId);
              },
            ),
          ],
        ),

        // BRANCH 3 – Admin Profile (OWN PROFILE)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/admin/profile",
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        
        // BRANCH 4 – Attendance
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/admin/attendance",
              builder: (context, state) => const AttendanceScreen(),
            ),
          ],
        ),
        
        // BRANCH 5 – Schedule
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/admin/schedule",
              builder: (context, state) => const ScheduleScreen(),
            ),
          ],
        ),
      ],
    ),

    // ========================================
    // USER SHELL ROUTES
    // ========================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => Scaffold(
        body: navigationShell,
        bottomNavigationBar: NavbarUser(navigationShell: navigationShell),
      ),
      branches: [
        // BRANCH 1 – Employee Home + Izin (FROM GROUP 1)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/home",
              builder: (context, state) => const HomeScreenUser(),
            ),
            GoRoute(
              path: "/izin",
              builder: (context, state) => LeaveRequestFormScreen(),
            ),
          ],
        ),
        
        // BRANCH 2 – Employee Profile (OWN PROFILE)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        
        // BRANCH 3 – Employee Attendance
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/attendance",
              builder: (context, state) => const AttendanceScreen(),
            ),
          ],
        ),
      ],
    ),

    // ========================================
    // NON-SHELL ROUTES (Full Screen)
    // ========================================

    // Edit Personal (Employee Mode)
    GoRoute(
      path: "/employee/edit-personal/:id",
      builder: (context, state) {
        final employee = state.extra as EmployeeModel?;

        if (employee == null) {
          return const Scaffold(
            body: Center(child: Text('Error: Data karyawan tidak ditemukan')),
          );
        }

        return EditPersonalScreen(employee: employee);
      },
    ),

    // Izin Detail (Admin)
    GoRoute(
      path: '/admin/izin/detail/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return AdminIzinDetailPage(id: id);
      },
    ),

    // ✅ DEPARTMENT CRUD (GROUP 2)
    GoRoute(
      path: "/admin/departments",
      builder: (context, state) => const DepartmentCrudScreen(),
    ),

    // ✅ POSITION CRUD (GROUP 2)
    GoRoute(
      path: "/admin/positions",
      builder: (context, state) => const PositionCrudScreen(),
    ),

    // Payroll (Requires Auth)
    GoRoute(
      path: "/payroll",
      builder: (context, state) => const PayrollScreen(),
    ),

    // ========================================
    // AUTHENTICATION ROUTES (PUBLIC)
    // ========================================
    GoRoute(
      path: "/login",
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: "/forgot-password",
      builder: (context, state) => ForgotPasswordScreen(),
    ),
    GoRoute(
      path: "/change-password",
      builder: (context, state) => const ChangePasswordScreen(),
    ),
  ],
);