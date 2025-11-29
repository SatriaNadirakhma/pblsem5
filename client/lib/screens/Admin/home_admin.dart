import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminHomeMain extends StatefulWidget {
  final Widget child;
  const AdminHomeMain({super.key, required this.child});

  @override
  State<AdminHomeMain> createState() => _AdminHomeMainState();
}

class _AdminHomeMainState extends State<AdminHomeMain> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // THIS IS THE MAGIC LINE — allows FAB to float over content
      body: widget.child,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
              switch (index) {
                case 0: context.goNamed('admin_home'); break;
                case 1: context.goNamed('laporan_izin'); break;
                case 2: context.goNamed('kelola_izin'); break;
              }
            },
            selectedItemColor: const Color(0xFF00A1D6),
            unselectedItemColor: Colors.grey[600],
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            showUnselectedLabels: true,
            selectedFontSize: 12,
            unselectedFontSize: 12,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home, size: 28), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart, size: 28), label: 'Laporan'),
              BottomNavigationBarItem(icon: Icon(Icons.assignment_outlined), activeIcon: Icon(Icons.assignment, size: 28), label: 'Kelola Izin'),
            ],
          ),
        ),
      ),
    );
  }
}