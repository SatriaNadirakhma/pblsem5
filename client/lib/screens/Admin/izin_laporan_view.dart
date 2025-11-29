// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:client/models/izin_dashboard_data.dart';

// class AdminIzinDashboard extends StatefulWidget {
//   const AdminIzinDashboard({super.key});

//   @override
//   State<AdminIzinDashboard> createState() => _AdminIzinDashboardState();
// }

// class _AdminIzinDashboardState extends State<AdminIzinDashboard> {
//   late Future<IzinDashboardData> _dashboardData;

//   @override
//   void initState() {
//     super.initState();
//     _dashboardData = _fetchDashboardData();
//   }

//   Future<IzinDashboardData> _fetchDashboardData() async {
//     final response = await http.get(
//       Uri.parse("http://192.168.30.157/api/izin-dashboard"),
//       headers: {'Accept': 'application/json'},
//     ).timeout(const Duration(seconds: 10));

//     if (response.statusCode == 200) {
//       return IzinDashboardData.fromJson(jsonDecode(response.body));
//     } else {
//       throw Exception('Gagal memuat data dashboard');
//     }
//   }

//   Future<void> _refresh() async {
//     setState(() {
//       _dashboardData = _fetchDashboardData();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: RefreshIndicator(
//         onRefresh: _refresh,
//         child: FutureBuilder<IzinDashboardData>(
//           future: _dashboardData,
//           builder: (context, snapshot) {
//             if (snapshot.hasData) {
//               final data = snapshot.data!;
//               return _buildDashboardContent(data);
//             } else if (snapshot.hasError) {
//               return Center(child: Text("Error: ${snapshot.error}"));
//             }
//             return const Center(child: CircularProgressIndicator(color: Color(0xFF00A1D6)));
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF00A1D6),
//         child: const Icon(Icons.menu, color: Colors.white),
//         onPressed: () => context.pushNamed('si_admin'),
//       ),
//     );
//   }

//   Widget _buildDashboardContent(IzinDashboardData data) {
//     return SingleChildScrollView(
//       physics: const AlwaysScrollableScrollPhysics(),
//       child: Column(
//         children: [
//           // HEADER
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
//             decoration: const BoxDecoration(
//               color: Color(0xFF00A1D6),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text('HRIS ANALYTICS', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 8),
//                 Text(
//                   'Update ${DateTime.now().day} ${['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'][DateTime.now().month]} ${DateTime.now().year}',
//                   style: const TextStyle(color: Colors.white70, fontSize: 16),
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     Expanded(child: _buildStatCard("${data.totalPending} / ${data.totalEmployees}", "Karyawan Ajukan Izin", Icons.person_outline)),
//                     const SizedBox(width: 16),
//                     Expanded(child: _buildStatCard("${data.totalValidated} / ${data.totalEmployees}", "Surat Izin Validate", Icons.check_circle_outline)),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 32),
//           const Padding(
//             padding: EdgeInsets.symmetric(horizontal: 24),
//             child: Text('SEMUA KARYAWAN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF00A1D6))),
//           ),
//           const SizedBox(height: 20),

//           // DEPARTMENT GRID
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1.8,
//               ),
//               itemCount: data.departments.length,
//               itemBuilder: (context, index) {
//                 final dept = data.departments[index];
//                 return _buildDepartmentCard(dept.name, "${dept.count} / ${data.totalEmployees}");
//               },
//             ),
//           ),
//           const SizedBox(height: 100),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatCard(String value, String label, IconData icon) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: Colors.white.withOpacity(0.25), borderRadius: BorderRadius.circular(16)),
//       child: Row(
//         children: [
//           CircleAvatar(radius: 24, backgroundColor: Colors.white.withOpacity(0.3), child: Icon(icon, size: 28, color: Colors.white)),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
//               Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDepartmentCard(String dept, String count) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(color: const Color(0xFF00C4D6), borderRadius: BorderRadius.circular(20)),
//       child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//         const CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Icon(Icons.person, size: 36, color: Color(0xFF00A1D6))),
//         const SizedBox(height: 12),
//         Text(count, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         Text(dept, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
//       ]),
//     );
//   }
// }