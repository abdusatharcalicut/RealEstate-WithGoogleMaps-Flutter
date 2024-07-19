class PropertyCategoryModel {
  PropertyCategoryModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PropertyCategoryModel.fromJson(Map<String, dynamic>? json) =>
      PropertyCategoryModel(
        id: json?["id"],
        name: json?["name"],
        createdAt: DateTime.tryParse(json?["createdAt"] ?? ""),
        updatedAt: DateTime.tryParse(json?["updatedAt"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
