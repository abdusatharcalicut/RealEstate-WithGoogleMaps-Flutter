class NewsCategoryModel {
  NewsCategoryModel({
    this.id,
    this.name,
    this.createdAt,
  });

  int? id;
  String? name;
  DateTime? createdAt;

  factory NewsCategoryModel.fromJson(Map<String, dynamic>? json) =>
      NewsCategoryModel(
        id: json?["id"],
        name: json?["name"],
        createdAt: DateTime.tryParse(json?["createdAt"] ?? ""),
      );
}
