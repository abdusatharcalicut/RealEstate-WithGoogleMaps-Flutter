import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:publrealty/exceptions/response_error.dart';
import 'package:publrealty/models/app_settings_model.dart';
import 'package:publrealty/models/base_response_model.dart';
import 'package:publrealty/models/news_model.dart';
import 'package:publrealty/models/property_model.dart';
import 'package:publrealty/service/request/search_property_request_model.dart';
import 'package:publrealty/service/response/dashboard_response_model.dart';
import 'package:publrealty/service/response/login_response_model.dart';
import 'package:publrealty/service/response/search_constants_response_model.dart';

class ApiService {
  static const baseUrl =
      "https://audito.in/"; //"http://publrealty.publsoft.com/"; "https://audito.in/";
  static const apiUrl = "${baseUrl}api/v1/";
  static const imagesUrl = "${baseUrl}uploadfiles/images/";

  static final Dio httpClient = Dio(
    BaseOptions(
      baseUrl: apiUrl,
      connectTimeout: 15000,
      receiveTimeout: 15000,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json"
      },
    ),
  );

  static Future<DashboardResponseModel> getDashboard() async {
    try {
      var response = await httpClient.get("dashboard");
      _validResponse(response);
      return DashboardResponseModel.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<SearchConstantsResponseModel> getSearchConstants() async {
    try {
      var response = await httpClient.get("properties/search/constants");
      _validResponse(response);
      return SearchConstantsResponseModel.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<PropertyModel>> searchProperties(
      SearchPropertyRequestModel model) async {
    try {
      var response =
          await httpClient.post("properties/search", data: jsonEncode(model));
      _validResponse(response);
      return List<PropertyModel>.from(
        response.data.map((x) => PropertyModel.fromJson(x)),
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<PropertyModel>> getLikedProperties() async {
    try {
      var response = await httpClient.get("properties/likes");
      _validResponse(response);
      return List<PropertyModel>.from(
        response.data.map((x) => PropertyModel.fromJson(x)),
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<void> likeProperty(int propertyId, bool isLiked) async {
    try {
      final response = await httpClient.post(
        "properties/like",
        data: {
          "propertyId": propertyId,
          "isLiked": isLiked,
        },
      );
      _validResponse(response);
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<AppSettingsModel> getAppSettings() async {
    try {
      var response = await httpClient.get("appsettings");
      _validResponse(response);
      return AppSettingsModel.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<List<NewsModel>> getNews() async {
    try {
      var response = await httpClient.get("news");
      _validResponse(response);
      return List<NewsModel>.from(
        response.data.map((x) => NewsModel.fromJson(x)),
      );
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<String> uploadProfileImage(XFile file) async {
    try {
      String fileName = file.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file.path, filename: fileName),
      });
      final response = await httpClient.post(
        "profile/updateprofileimage",
        data: formData,
      );
      _validResponse(response);
      return Future.value(response.data.toString());
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<LoginResponseModel> login(
      String username, String password) async {
    try {
      final reqModel = {"username": username, "password": password};

      var response =
          await httpClient.post("auth/login", data: jsonEncode(reqModel));

      _validResponse(response);

      return LoginResponseModel.fromJson(response.data);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<LoginResponseModel> register({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final reqModel = {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "username": username,
        "password": password,
      };

      final response =
          await httpClient.post("auth/register", data: jsonEncode(reqModel));
      _validResponse(response);

      return login(username, password);
    } catch (e) {
      return Future.error(e);
    }
  }

  static _validResponse(Response<dynamic> response) {
    if (response.data is Map<String, dynamic>?) {
      final data = ResponseValidationModel.fromJson(response.data);
      if (data.error != null && data.error?.message != null) {
        throw ResponseError(message: data.error?.message);
      }
    }
  }
}
