import 'package:publrealty/models/news_category_model.dart';

class NewsModel {
  NewsModel({
    this.id,
    this.title,
    this.content,
    this.imageName,
    this.createdAt,
    this.category,
  });

  int? id;
  String? title;
  String? content;
  String? imageName;
  DateTime? createdAt;
  NewsCategoryModel? category;

  factory NewsModel.fromJson(Map<String, dynamic>? json) => NewsModel(
        id: json?["id"],
        title: json?["title"],
        content: json?["content"],
        imageName: json?["imageName"],
        createdAt: DateTime.tryParse(json?["createdAt"] ?? ""),
        category: json?["category"] == null
            ? null
            : NewsCategoryModel.fromJson(json!["category"]),
      );
}
