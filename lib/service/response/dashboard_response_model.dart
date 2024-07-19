import 'package:publrealty/models/city_model.dart';
import 'package:publrealty/models/property_model.dart';

class DashboardResponseModel {
  DashboardResponseModel({
    this.headerImages,
    this.featuredProperties,
    this.newProperties,
    this.topSearchCities,
  });

  List<String>? headerImages;
  List<PropertyModel>? featuredProperties;
  List<PropertyModel>? newProperties;
  List<CityModel>? topSearchCities;

  factory DashboardResponseModel.fromJson(Map<String, dynamic>? json) =>
      DashboardResponseModel(
        headerImages: List<String>.from(json?["headerImages"].map((x) => x)),
        featuredProperties: List<PropertyModel>.from(
            json?["featuredProperties"].map((x) => PropertyModel.fromJson(x))),
        newProperties: List<PropertyModel>.from(
            json?["newProperties"].map((x) => PropertyModel.fromJson(x))),
        topSearchCities: List<CityModel>.from(
            json?["topSearchCities"].map((x) => CityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "headerImages": List<String>.from(headerImages?.map((x) => x) ?? []),
        "featuredProperties": List<dynamic>.from(
            featuredProperties?.map((x) => x.toJson()) ?? []),
        "newProperties": List<dynamic>.from(
            newProperties?.map((x) => x.toJson()) ?? []),
        "topSearchCities":
            List<dynamic>.from(topSearchCities?.map((x) => x.toJson()) ?? []),
      };
}
