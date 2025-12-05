class EmployeeModel {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String gender;
  final String address;
  final String createdAt;
  final String updatedAt;
  final String position;
  final String department;
  final String employementStatus;

  EmployeeModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.position,
    required this.department,
    required this.employementStatus,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json["id"].toString(),
      userId: json["user_id"].toString(),
      firstName: json["first_name"] ?? "",
      lastName: json["last_name"] ?? "",
      gender: json["gender"] ?? "",
      address: json["address"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      position: json["position"]["name"] ?? "",
      department: json["department"]["name"] ?? "",
      employementStatus:
          json["employment_status"] ?? json["employement_status"] ?? "",
    );
  }
}
