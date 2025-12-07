class PositionModel {
  final int id;
  final String name;
  final double? rateReguler; 
  final double? rateOvertime;
  final String? createdAt;
  final String? updatedAt;

  PositionModel({
    required this.id,
    required this.name,
    this.rateReguler,
    this.rateOvertime,
    this.createdAt,
    this.updatedAt,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      id: json['id'] as int,
      name: json['name'] as String,
      // ✅ FIX: Handle null values properly
      rateReguler: json['rate_reguler'] != null
          ? (json['rate_reguler'] is int
                ? (json['rate_reguler'] as int).toDouble()
                : double.tryParse(json['rate_reguler'].toString()))
          : null,
      rateOvertime: json['rate_overtime'] != null
          ? (json['rate_overtime'] is int
                ? (json['rate_overtime'] as int).toDouble()
                : double.tryParse(json['rate_overtime'].toString()))
          : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'rate_reguler': rateReguler,
      'rate_overtime': rateOvertime,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
