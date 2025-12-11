class LetterModel {
  final String employeeName;
  final String departmentName;
  final String cutiType;
  final String cutiDate;

  LetterModel({
    required this.employeeName,
    required this.departmentName,
    required this.cutiType,
    required this.cutiDate,
  });

  // ✅ From JSON
  factory LetterModel.fromJson(Map<String, dynamic> json) {
    return LetterModel(
      employeeName: json['employee_name'] ?? 'Tanpa Nama',
      departmentName: json['department_name'] ?? '-',
      cutiType: json['cuti_type'] ?? '-',
      cutiDate: json['cuti_date'] ?? '-',
    );
  }

  // ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'employee_name': employeeName,
      'department_name': departmentName,
      'cuti_type': cutiType,
      'cuti_date': cutiDate,
    };
  }

  @override
  String toString() {
    return 'LetterModel(employee: $employeeName, type: $cutiType, date: $cutiDate)';
  }
}