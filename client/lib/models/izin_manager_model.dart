class IzinModel {
  final int id;
  final int statusCode;
  final String statusText;
  final String date;
  final String fullName;
  final String position;
  final String department;

  IzinModel({
    required this.id,
    required this.statusCode,
    required this.statusText,
    required this.date,
    required this.fullName,
    required this.position,
    required this.department,
  });

  factory IzinModel.fromJson(Map<String, dynamic> json) {
    final int? rawStatus = json["status"] as int?;
    String statusText;
    switch (rawStatus) {
      case 0:
        statusText = "Diproses";
        break;
      case 1:
        statusText = "Diterima";
        break;
      case 2:
        statusText = "Ditolak";
        break;
      default:
        statusText = "Unknown";
    }

    return IzinModel(
      id: json["id"] ?? 0,
      statusCode: rawStatus ?? -1,
      statusText: statusText,
      date: json["date"]?.toString() ?? "",
      fullName: json["full_name"]?.toString() ?? "",
      position: json["position"]?.toString() ?? "",
      department: json["department_name"]?.toString() ?? "",
    );
  }
}
