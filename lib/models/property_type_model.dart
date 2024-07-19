class PropertyTypeModel {
  PropertyTypeModel({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PropertyTypeModel.fromJson(Map<String, dynamic>? json) =>
      PropertyTypeModel(
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
