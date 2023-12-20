import 'package:e3tmed/models/IModelFactory.dart';

class LoginResult implements IJsonSerializable {
  final String phoneNumber;
  final String? email;
  final int userId;
  final String token;
  final int expiresIn;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? city;
  final String? region;
  final String? address;
  final String? role;

  LoginResult(
      this.phoneNumber,
      this.email,
      this.userId,
      this.token,
      this.expiresIn,
      this.firstName,
      this.lastName,
      this.country,
      this.city,
      this.region,
      this.address,
      this.role);

  @override
  Map<String, dynamic> toJson() {
    return {
      "phoneNumber": phoneNumber,
      "email": email,
      "userId": userId,
      "token": token,
      "expiresIn": expiresIn,
      "firstName": firstName,
      "lastName": lastName,
      "country": country,
      "city": city,
      "region": region,
      "address": address,
      "role": role
    };
  }
}

class LoginResultFactory implements IModelFactory<LoginResult> {
  @override
  LoginResult fromJson(Map<String, dynamic> jsonMap) {
    return LoginResult(
        jsonMap["phoneNumber"],
        jsonMap["email"],
        jsonMap["userId"],
        jsonMap["token"],
        jsonMap["expiresIn"],
        jsonMap["firstName"],
        jsonMap["lastName"],
        jsonMap["country"],
        jsonMap["city"],
        jsonMap["region"],
        jsonMap["address"],
        jsonMap["role"]);
  }
}

class UserInfo implements IJsonSerializable {
  final String phoneNumber;
  final String? email;
  final int userId;
  final String? firstName;
  final String? lastName;
  final String? country;
  final String? city;
  final String? region;
  final String? address;

  String get name =>
      "${(firstName == null ? "" : "$firstName ")}${lastName ?? ""}";

  UserInfo(this.phoneNumber, this.email, this.userId, this.firstName,
      this.lastName, this.country, this.city, this.region, this.address);

  @override
  Map<String, dynamic> toJson() {
    return {
      "phoneNumber": phoneNumber,
      "email": email,
      "id": userId,
      "firstName": firstName,
      "lastName": lastName,
      "country": country,
      "city": city,
      "region": region,
      "address": address,
    };
  }
}

class UserInfoFactory implements IModelFactory<UserInfo> {
  @override
  UserInfo fromJson(Map<String, dynamic> jsonMap) {
    return UserInfo(
        jsonMap["phoneNumber"],
        jsonMap["email"],
        jsonMap["id"],
        jsonMap["firstName"],
        jsonMap["lastName"],
        jsonMap["country"],
        jsonMap["city"],
        jsonMap["region"],
        jsonMap["address"]);
  }
}
