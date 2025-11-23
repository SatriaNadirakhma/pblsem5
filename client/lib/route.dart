import 'package:client/screens/home_screen.dart';
import 'package:client/screens/login_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: "/login",
  redirect: (context, state) {
    return;
  },
  routes: [
    GoRoute(
      path: "/",
      name: "home",
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: "/login",
      name: "login",
      builder: (context, state) => const LoginScreen(),
    ),
  ],
);
