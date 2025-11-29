class IzinDashboardData {
  final int totalPending;      // 16 / 120
  final int totalValidated;    // 12 / 120
  final int totalEmployees;
  final List<DepartmentStat> departments;

  IzinDashboardData({
    required this.totalPending,
    required this.totalValidated,
    required this.totalEmployees,
    required this.departments,
  });

  factory IzinDashboardData.fromJson(Map<String, dynamic> json) {
    var deptList = json['departments'] as List;
    List<DepartmentStat> deptStats = deptList
        .map((d) => DepartmentStat.fromJson(d))
        .toList();

    return IzinDashboardData(
      totalPending: json['total_pending'] ?? 0,
      totalValidated: json['total_validated'] ?? 0,
      totalEmployees: json['total_employees'] ?? 0,
      departments: deptStats,
    );
  }
}

class DepartmentStat {
  final String name;
  final int count;

  DepartmentStat({required this.name, required this.count});

  factory DepartmentStat.fromJson(Map<String, dynamic> json) {
    return DepartmentStat(
      name: json['department_name'] ?? 'Unknown Dept',
      count: json['izin_count'] ?? 0,
    );
  }
}