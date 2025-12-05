import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:client/models/izin_manager_model.dart';
import 'package:client/services/izin_manager_service.dart';

class AdminIzinManager extends StatefulWidget {
  const AdminIzinManager({super.key});

  @override
  State<AdminIzinManager> createState() => _AdminIzinManagerState();
}

class _AdminIzinManagerState extends State<AdminIzinManager> {
  final IzinService izinService = IzinService();

  List<IzinModel> izinData = [];
  String selectedFilter = "All";

  bool loading = true;

  int approvedOrRejected = 0;
  int pending = 0;

  @override
  void initState() {
    super.initState();
    loadDashboard();
    loadIzinList();
  }

  // =================== DASHBOARD ===================
  Future<void> loadDashboard() async {
    try {
      final data = await izinService.loadDashboard();
      if (!mounted) return;

      setState(() {
        approvedOrRejected = data["approvedOrRejected"] ?? 0;
        pending = data["pending"] ?? 0;
      });
    } catch (e) {
      debugPrint("ERROR DASHBOARD: $e");
    }
  }

  // =================== LOAD IZIN LIST ===================
  Future<void> loadIzinList() async {
    try {
      setState(() => loading = true);

      final result = await izinService.loadIzinList();
      if (!mounted) return;

      setState(() {
        izinData = result;
        loading = false;
      });
    } catch (e) {
      debugPrint("ERROR LOAD LIST: $e");
      if (mounted) setState(() => loading = false);
    }
  }

  // =================== UPDATE STATUS ===================
  Future<void> updateStatus(int id, int newStatus) async {
    try {
      final success = await izinService.updateStatus(id, newStatus);

      if (success) {
        await loadIzinList();

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Status berhasil diperbarui")),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memperbarui status")),
        );
      }
    } catch (e) {
      debugPrint("ERROR UPDATE STATUS: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memperbarui status")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = selectedFilter == "All"
        ? izinData
        : izinData.where((item) => item.statusCode.toString() == selectedFilter).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildDashboardHeader(),
            const SizedBox(height: 20),
            _buildFilterHeader(),
            const SizedBox(height: 15),
            loading ? _buildLoadingIndicator() : _buildIzinList(filteredData),
          ],
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF00A8E8),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.go('/'),
      ),
      centerTitle: true,
      title: const Text(
        "HRIS Manajemen Izin",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: Colors.white,
            child: Icon(Icons.apartment, color: Colors.blue),
          ),
        ),
      ],
    );
  }

  Widget _buildDashboardHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0DB4E5),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildSummaryCard(),
          const SizedBox(height: 25),
          _buildTemplateMenu(),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.people, size: 35),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$approvedOrRejected / $pending",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                "Surat Izin Diproses",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateMenu() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 50),
        children: [
          izinCardWithIcon(
            title: "Buat Template",
            icon: Icons.add_circle_outline,
            onTap: () => context.push("/admin/template/add"),
          ),
          izinCardWithIcon(
            title: "List Template",
            icon: Icons.list_alt,
            onTap: () => context.push("/admin/template/list"),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Update List",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: () => showFilterSheet(context),
            child: const Icon(Icons.filter_list, size: 26),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildIzinList(List<IzinModel> data) {
    return Column(
      children: data.map((item) => izinListItem(
        id: item.id,
        statusCode: item.statusCode,
        status: item.statusText,
        date: item.date,
        fullName: item.fullName,
        position: item.position,
        department: item.department,
      )).toList(),
    );
  }

  // ================= FILTER SHEET =================
  void showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              filterOption("Semua", "All"),
              filterOption("Diproses", "0"),
              filterOption("Diterima", "1"),
              filterOption("Ditolak", "2"),
            ],
          ),
        );
      },
    );
  }

  Widget filterOption(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing:
          selectedFilter == value ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () {
        setState(() => selectedFilter = value);
        Navigator.pop(context);
      },
    );
  }

  // ================= ITEM IZIN =================
  Widget izinListItem({
    required int id,
    required int statusCode,
    required String status,
    required String date,
    required String fullName,
    required String position,
    required String department,
  }) {
    final color = status == "Diproses"
        ? Colors.orange
        : status == "Diterima"
            ? Colors.green
            : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            offset: const Offset(0, 3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 15),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text(fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                Text(
                  "Jabatan: $position\nDepartemen: $department",
                  style: const TextStyle(fontSize: 11, height: 1.3, color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // STATUS + ACTION
          Row(
            children: [
              Container(
                constraints: const BoxConstraints(minWidth: 80),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: color),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
              statusCode == 0
                  ? PopupMenuButton<int>(
                      onSelected: (value) => updateStatus(id, value),
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 1, child: Text("Diterima")),
                        PopupMenuItem(value: 2, child: Text("Ditolak")),
                      ],
                    )
                  : const SizedBox(width: 45),
            ],
          ),
        ],
      ),
    );
  }

  // ================= TEMPLATE CARD =================
  Widget izinCardWithIcon({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
