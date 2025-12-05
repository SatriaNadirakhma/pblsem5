class LeaveReportResponse {
  final int totalEmployeesWithLetters;
  final int totalEmployees;
  final int totalLettersApproved;
  final int totalLetters;
  final List<dynamic> departments;
  final List<dynamic> allLetters;

  LeaveReportResponse({
    required this.totalEmployeesWithLetters,
    required this.totalEmployees,
    required this.totalLettersApproved,
    required this.totalLetters,
    required this.departments,
    required this.allLetters,
  });

  factory LeaveReportResponse.fromJson(Map<String, dynamic> json) {
    return LeaveReportResponse(
      totalEmployeesWithLetters: json["total_employees_with_letters"],
      totalEmployees: json["total_employees"],
      totalLettersApproved: json["total_letters_approved"],
      totalLetters: json["total_letters"],
      departments: json["departments"] ?? [],
      allLetters: json["all_letters"] ?? [],
    );
  }
}
