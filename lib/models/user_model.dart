class UserModel {
  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.imageName,
    this.phoneNumber,
    this.email,
    this.username,
    this.address,
    this.latitude,
    this.longitude,
    this.isAdmin,
    this.isAgent,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? firstName;
  String? lastName;
  String? imageName;
  String? phoneNumber;
  String? email;
  String? username;
  String? address;
  double? latitude;
  double? longitude;
  String? isAdmin;
  String? isAgent;
  bool? emailVerifiedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserModel.fromJson(Map<String, dynamic>? json) => UserModel(
        id: json?["id"],
        firstName: json?["firstName"],
        lastName: json?["lastName"],
        imageName: json?["imageName"],
        phoneNumber: json?["phoneNumber"],
        email: json?["email"],
        username: json?["username"],
        address: json?["address"],
        latitude: json?["latitude"],
        longitude: json?["longitude"],
        isAdmin: json?["isAdmin"],
        isAgent: json?["isAgent"],
        emailVerifiedAt: json?["emailVerifiedAt"],
        createdAt: DateTime.tryParse(json?["createdAt"] ?? ""),
        updatedAt: DateTime.tryParse(json?["updatedAt"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "imageName": imageName,
        "phoneNumber": phoneNumber,
        "email": email,
        "username": username,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "isAdmin": isAdmin,
        "isAgent": isAgent,
        "emailVerifiedAt": emailVerifiedAt,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
