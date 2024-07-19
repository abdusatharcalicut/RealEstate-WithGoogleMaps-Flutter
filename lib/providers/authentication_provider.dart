import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:publrealty/models/user_model.dart';
import 'package:publrealty/service/ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  static AuthenticationProvider of(BuildContext context, {listen = false}) =>
      Provider.of<AuthenticationProvider>(context, listen: listen);

  static const _keyUser = "user";
  static const _keyAccessToken = "accessToken";

  bool isLoggedIn = false;
  UserModel? user;

  Future<void> prepare() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_keyUser);
    final accessToken = prefs.getString(_keyAccessToken);

    if (userJson == null || accessToken == null) {
      return;
    }

    ApiService.httpClient.options.headers["Authorization"] =
        "Bearer $accessToken";

    user = UserModel.fromJson(jsonDecode(userJson));
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> login(UserModel user, String accessToken) async {
    ApiService.httpClient.options.headers["Authorization"] =
        "Bearer $accessToken";

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_keyUser, jsonEncode(user.toJson()));
    prefs.setString(_keyAccessToken, accessToken);

    this.user = user;
    isLoggedIn = true;
    notifyListeners();
  }

  Future<void> updateUserModelInLocalStorage() async {
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(_keyUser, jsonEncode(user!.toJson()));
    }
    return Future.value();
  }

  Future<void> logout() async {
    ApiService.httpClient.options.headers["Authorization"] = "";

    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_keyUser);
    prefs.remove(_keyAccessToken);

    user = null;
    isLoggedIn = false;
    notifyListeners();
  }
}
