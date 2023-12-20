import 'package:e3tmed/models/IModelFactory.dart';

class UserAddress implements IJsonSerializable {
  int id;
  bool isPrimary;
  String country;
  String city;
  String region;
  String address;

  UserAddress(
      {required this.id,
      required this.isPrimary,
      required this.country,
      required this.city,
      required this.region,
      required this.address});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "isPrimary": isPrimary,
        "country": country,
        "city": city,
        "region": region,
        "address": address
      };
}

class UserAddressFactory implements IModelFactory<UserAddress> {
  @override
  UserAddress fromJson(Map<String, dynamic> jsonMap) {
    return UserAddress(
        id: jsonMap["id"],
        isPrimary: jsonMap["isPrimary"],
        country: jsonMap["country"],
        city: jsonMap["city"],
        region: jsonMap["region"],
        address: jsonMap["address"]);
  }
}
