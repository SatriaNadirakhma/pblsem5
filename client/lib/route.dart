import 'package:client/models/employee_model.dart';
import 'package:client/screens/groupTwo/employee_detail_screen.dart';
import 'package:client/screens/groupTwo/employee_list_screen.dart';
import 'package:client/screens/groupTwo/role_selection_screen.dart';
import 'package:client/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: "/role-selection",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return Scaffold(
          body: navigationShell,
          bottomNavigationBar: Navbar(navigationShell: navigationShell),
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/home",
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/profile",
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
      ],
    ),

    // Non-nav pages (full screen)
    GoRoute(path: "/login", builder: (context, state) => const LoginScreen()),

    // ========================================
    // GROUP TWO ROUTES - KARYAWAN MODE
    // ========================================

    // Role selection screen
    GoRoute(
      path: "/role-selection",
      builder: (context, state) => const RoleSelectionScreen(),
    ),

    // Employee list (Karyawan mode)
    GoRoute(
      path: "/employee-list",
      builder: (context, state) =>
          const EmployeeListScreen(isKaryawanMode: true),
    ),

    // Employee detail
    GoRoute(
      path: "/employee-detail/:id",
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null) {
          return const Scaffold(
            body: Center(child: Text('Error: Data karyawan tidak ditemukan')),
          );
        }

        final employee = extra['employee'] as EmployeeModel;
        final isKaryawanMode = extra['isKaryawanMode'] as bool;

        return EmployeeDetailScreen(
          employee: employee,
          isKaryawanMode: isKaryawanMode,
        );
      },
    ),

    // Edit personal info (Karyawan mode)
    GoRoute(
      path: "/employee/edit-personal/:id",
      builder: (context, state) {
        final employee = state.extra as EmployeeModel?;

        if (employee == null) {
          return const Scaffold(
            body: Center(child: Text('Error: Data karyawan tidak ditemukan')),
          );
        }

        return Placeholder(
          child: Center(
            child: Text(
              'Edit Personal Screen\nEmployee: ${employee.fullName}\nComing Soon',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    ),

    // Admin dashboard (placeholder)
    GoRoute(
      path: "/admin-dashboard",
      builder: (context, state) => const Placeholder(
        child: Center(child: Text('Admin Dashboard - Coming Soon')),
      ),
    ),
  ],
);
