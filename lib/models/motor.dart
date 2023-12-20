import 'package:e3tmed/models/IModelFactory.dart';

import '../DI.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';

class Motor implements IJsonSerializable {
  int id;
  String nameAr;
  String nameEn;
  double price;
  bool isOutOfStock;

  Motor(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.price,
      required this.isOutOfStock});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nameAr": nameAr,
        "nameEn": nameEn,
        "price": price,
        "isOutOfStock": isOutOfStock
      };

  String getMotorName() {
    if (useLanguage == Languages.arabic.name) {
      return nameAr;
    } else {
      return nameEn;
    }
  }
}

class MotorFactory implements IModelFactory<Motor> {
  @override
  Motor fromJson(Map<String, dynamic> jsonMap) {
    return Motor(
        id: jsonMap["id"],
        nameAr: jsonMap["nameAr"],
        nameEn: jsonMap["nameEn"],
        price: jsonMap["price"].toDouble(),
        isOutOfStock: jsonMap["isOutOfStock"]);
  }
}
