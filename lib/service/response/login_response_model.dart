import 'package:publrealty/models/user_model.dart';

class LoginResponseModel {
  LoginResponseModel({this.user, this.token, error});

  UserModel? user;
  String? token;

  factory LoginResponseModel.fromJson(Map<String, dynamic>? json) =>
      LoginResponseModel(
        user: UserModel.fromJson(json?["user"]),
        token: json?["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
      };
}
