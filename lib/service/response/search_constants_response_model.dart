import 'package:publrealty/models/city_model.dart';
import 'package:publrealty/models/property_category_model.dart';
import 'package:publrealty/models/property_type_model.dart';

class SearchConstantsResponseModel {
  SearchConstantsResponseModel({
    this.propertyTypes,
    this.propertyCategories,
    this.cities,
  });

  List<PropertyTypeModel>? propertyTypes;
  List<PropertyCategoryModel>? propertyCategories;
  List<CityModel>? cities;

  factory SearchConstantsResponseModel.fromJson(Map<String, dynamic>? json) =>
      SearchConstantsResponseModel(
        propertyTypes: List<PropertyTypeModel>.from(
            json?["propertyTypes"].map((x) => PropertyTypeModel.fromJson(x)) ??
                []),
        propertyCategories: List<PropertyCategoryModel>.from(
            json?["propertyCategories"]
                    .map((x) => PropertyCategoryModel.fromJson(x)) ??
                []),
        cities: List<CityModel>.from(
            json?["cities"].map((x) => CityModel.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "propertyTypes": List<String>.from(propertyTypes?.map((x) => x) ?? []),
        "propertyCategories":
            List<String>.from(propertyCategories?.map((x) => x) ?? []),
        "cities": List<String>.from(cities?.map((x) => x) ?? []),
      };
}
