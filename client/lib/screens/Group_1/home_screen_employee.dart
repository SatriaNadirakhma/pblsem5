import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreenUser extends StatelessWidget {
  const HomeScreenUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // HEADER
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(
                  24,
                  MediaQuery.of(context).padding.top + 20,
                  24,
                  30,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF00A1D6), Color(0xFF00C4D6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'HRIS Sistem',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          child: const Icon(
                            Icons.business,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Pilih menu untuk memulai',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),

            // MENU GRID (3 Cards Only)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: MediaQuery.of(context).size.width > 400
                      ? 1.1
                      : 1.0,
                ),
                delegate: SliverChildListDelegate([
                  // Card 1: Izin Cuti
                  _buildMenuCard(
                    context,
                    icon: Icons.assignment,
                    title: 'Izin Cuti',
                    subtitle: 'Pengajuan izin',
                    color: const Color(0xFF3674B5),
                    onTap: () => context.go('/izin'),
                  ),

                  // Card 2: Absensi (Updated Route)
                  _buildMenuCard(
                    context,
                    icon: Icons.access_time,
                    title: 'Absensi',
                    subtitle: 'Sistem kehadiran',
                    color: const Color(0xFF3674B5),
                    onTap: () =>
                        context.go('/attendance'), // ✅ Changed to /attendance
                  ),

                  // Card 3: Slip Gaji
                  _buildMenuCard(
                    context,
                    icon: Icons.payment,
                    title: 'Slip Gaji',
                    subtitle: 'Detail gaji',
                    color: const Color(0xFF4E71FF),
                    onTap: () => context.pushNamed('payroll'),
                  ),

                  // ❌ REMOVED: Karyawan card
                ]),
              ),
            ),

            // FOOTER
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 40),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.18),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 36, color: Colors.white),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
