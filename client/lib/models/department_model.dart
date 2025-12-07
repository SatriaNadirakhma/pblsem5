class DepartmentModel {
  final int id;
  final String name;
  final double? latitude; // ✅ Make nullable
  final double? longitude; // ✅ Make nullable
  final int? radiusMeters; // ✅ Make nullable
  final String? createdAt;
  final String? updatedAt;

  DepartmentModel({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    this.radiusMeters,
    this.createdAt,
    this.updatedAt,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      // ✅ FIX: Handle null values properly
      latitude: json['latitude'] != null
          ? (json['latitude'] is double
                ? json['latitude'] as double
                : (json['latitude'] is int
                      ? (json['latitude'] as int).toDouble()
                      : double.tryParse(json['latitude'].toString())))
          : null,
      longitude: json['longitude'] != null
          ? (json['longitude'] is double
                ? json['longitude'] as double
                : (json['longitude'] is int
                      ? (json['longitude'] as int).toDouble()
                      : double.tryParse(json['longitude'].toString())))
          : null,
      radiusMeters: json['radius_meters'] != null
          ? (json['radius_meters'] is int
                ? json['radius_meters'] as int
                : int.tryParse(json['radius_meters'].toString()))
          : null,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'radius_meters': radiusMeters,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
