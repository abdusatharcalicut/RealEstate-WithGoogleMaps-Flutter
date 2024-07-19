class CityModel {
  CityModel({
    this.id,
    this.name,
    this.imageName,
    this.searchCount,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? imageName;
  String? searchCount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CityModel.fromJson(Map<String, dynamic>? json) => CityModel(
        id: json?["id"],
        name: json?["name"],
        imageName: json?["imageName"],
        searchCount: json?["searchCount"],
        createdAt: DateTime.tryParse(json?["createdAt"] ?? ""),
        updatedAt: DateTime.tryParse(json?["updatedAt"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imageName": imageName,
        "searchCount": searchCount,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  get(String s) {}
}
