import 'package:publrealty/models/city_model.dart';
import 'package:publrealty/models/property_category_model.dart';
import 'package:publrealty/models/property_type_model.dart';

class SearchPropertyRequestModel {
  SearchPropertyRequestModel({
    this.searchText,
    this.propertyTypes,
    this.propertyCategories,
    this.cities,
    this.bedRoomCounts,
    this.bathRoomCounts,
    this.kitchenRoomCounts,
    this.parkingCounts,
    this.minSize,
    this.maxSize,
    this.minPrice,
    this.maxPrice,
    this.address,
  });

  String? searchText;
  List<PropertyTypeModel>? propertyTypes;
  List<PropertyCategoryModel>? propertyCategories;
  List<CityModel>? cities;
  List<int>? bedRoomCounts;
  List<int>? bathRoomCounts;
  List<int>? kitchenRoomCounts;
  List<int>? parkingCounts;
  double? minSize;
  double? maxSize;
  double? minPrice;
  double? maxPrice;
  String? address;

  Map<String, dynamic> toJson() => {
        "searchText": searchText,
        "propertyTypes": propertyTypes == null
            ? null
            : List<dynamic>.from(propertyTypes!.map((x) => x.toJson())),
        "propertyCategories": propertyCategories == null
            ? null
            : List<dynamic>.from(propertyCategories!.map((x) => x.toJson())),
        "cities": cities == null
            ? null
            : List<dynamic>.from(cities!.map((x) => x.toJson())),
        "bedRoomCounts": bedRoomCounts,
        "bathRoomCounts": bathRoomCounts,
        "kitchenRoomCounts": kitchenRoomCounts,
        "parkingCounts": parkingCounts,
        "minSize": minSize,
        "maxSize": maxSize,
        "minPrice": minPrice,
        "maxPrice": maxPrice,
        "address": address,
      };
}
