class TemplateModel {
  final int id;
  final String name;
  final String content;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TemplateModel({
    required this.id,
    required this.name,
    required this.content,
    this.createdAt,
    this.updatedAt,
  });

  // From JSON (Sesuai dengan response API)
  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : null,
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
    );
  }

  // To JSON (untuk kirim data ke API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}