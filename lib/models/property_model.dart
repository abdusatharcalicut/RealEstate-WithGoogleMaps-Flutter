import 'package:publrealty/models/city_model.dart';
import 'package:publrealty/models/property_category_model.dart';
import 'package:publrealty/models/property_type_model.dart';
import 'package:publrealty/models/user_model.dart';

class PropertyModel {
  PropertyModel({
    this.id,
    this.propertyTypeId,
    this.propertyCategoryId,
    this.userId,
    this.cityId,
    this.featured,
    this.title,
    this.description,
    this.imageNames,
    this.size,
    this.bedRoomCount,
    this.bathRoomCount,
    this.kitchenRoomCount,
    this.parkingCount,
    this.additionalFeatures,
    this.price,
    this.currency,
    this.address,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.visible,
    this.propertyType,
    this.propertyCategory,
    this.user,
    this.city,
  });

  int? id;
  String? propertyTypeId;
  String? propertyCategoryId;
  String? userId;
  String? cityId;
  String? featured;
  String? title;
  String? description;
  String? imageNames;
  String? size;
  String? bedRoomCount;
  String? bathRoomCount;
  String? kitchenRoomCount;
  String? parkingCount;
  String? additionalFeatures;
  String? price;
  String? currency;
  String? address;
  String? latitude;
  String? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? visible;
  PropertyTypeModel? propertyType;
  PropertyCategoryModel? propertyCategory;
  UserModel? user;
  CityModel? city;

  factory PropertyModel.fromJson(Map<String, dynamic>? json) => PropertyModel(
        id: json?["id"],
        propertyTypeId: json?["propertyTypeId"],
        propertyCategoryId: json?["propertyCategoryId"],
        userId: json?["userId"],
        cityId: json?["cityId"],
        featured: json?["featured"],
        title: json?["title"],
        description: json?["description"],
        imageNames: json?["imageNames"],
        size: json?["size"],
        bedRoomCount: json?["bedRoomCount"],
        bathRoomCount: json?["bathRoomCount"],
        kitchenRoomCount: json?["kitchenRoomCount"],
        parkingCount: json?["parkingCount"],
        additionalFeatures: json?["additionalFeatures"],
        price: json?["price"],
        currency: json?["currency"],
        address: json?["address"],
        latitude: json?["latitude"],
        longitude: json?["longitude"],
        createdAt: DateTime.tryParse(json?["createdAt"] ?? ""),
        updatedAt: DateTime.tryParse(json?["updatedAt"] ?? ""),
        visible: json?["visible"],
        propertyType: PropertyTypeModel.fromJson(json?["propertyType"]),
        propertyCategory:
            PropertyCategoryModel.fromJson(json?["propertyCategory"]),
        user: UserModel.fromJson(json?["user"]),
        city: CityModel.fromJson(json?["city"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "propertyTypeId": propertyTypeId,
        "propertyCategoryId": propertyCategoryId,
        "userId": userId,
        "cityId": cityId,
        "featured": featured,
        "title": title,
        "description": description,
        "imageNames": imageNames,
        "size": size,
        "bedRoomCount": bedRoomCount,
        "bathRoomCount": bathRoomCount,
        "kitchenRoomCount": kitchenRoomCount,
        "parkingCount": parkingCount,
        "additionalFeatures": additionalFeatures,
        "price": price,
        "currency": currency,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "visible": visible,
        "propertyType": propertyType?.toJson(),
        "propertyCategory": propertyCategory?.toJson(),
        "user": user?.toJson(),
        "city": city?.toJson(),
      };
}
