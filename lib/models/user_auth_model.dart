import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:injector/injector.dart';

class UserAuthModel implements IJsonSerializable {
  int userId;
  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? imageUrl;
  String? phone;
  String? token;
  String? country;
  String? city;
  String? region;
  String? address;

  UserAuthModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.imageUrl,
      required this.token,
      required this.address,
      required this.region,
      required this.city,
      required this.country,
      required this.userId,
      required this.firstName,
      required this.lastName});

  @override
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "phone": phone,
        "imageUrl": imageUrl,
        "token": token,
        "address": address,
        "region": region,
        "city": city,
        "country": country,
        "userId": userId,
        "firstName": firstName,
        "lastName": lastName,
      };
}

class UserAuthModelFactory implements IModelFactory<UserAuthModel> {
  @override
  UserAuthModel fromJson(Map<String, dynamic> jsonMap) {
    return UserAuthModel(
      name: jsonMap["name"],
      email: jsonMap["email"],
      phone: jsonMap["phone"],
      imageUrl: jsonMap["imageUrl"],
      token: jsonMap["token"],
      address: jsonMap["address"],
      region: jsonMap["region"],
      city: jsonMap["city"],
      country: jsonMap["country"],
      userId: jsonMap["userId"],
      firstName: jsonMap["firstName"],
      lastName: jsonMap["lastName"],
    );
  }
}

class RegistrationResult {
  bool success;
  bool phoneConflict;
  bool emailConflict;

  RegistrationResult(
      {required this.success,
      required this.phoneConflict,
      required this.emailConflict});
}
