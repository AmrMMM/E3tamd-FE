import 'package:e3tmed/models/IModelFactory.dart';

import '../DI.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';

class Category implements IJsonSerializable {
  int id;
  int? maintenanceCategoryId;
  String nameAr;
  String nameEn;
  Category(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.maintenanceCategoryId});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nameAr": nameAr,
        "nameEn": nameEn,
        "maintenanceCategoryId": maintenanceCategoryId
      };

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return (other as Category).id == id;
  }

  @override
  int get hashCode => id;

  String getName() {
    if (useLanguage == Languages.arabic.name) {
      return nameAr;
    } else {
      return nameEn;
    }
  }
}

class CategoryFactory implements IModelFactory<Category> {
  @override
  Category fromJson(Map<String, dynamic> jsonMap) {
    return Category(
        id: jsonMap["id"],
        nameAr: jsonMap["nameAr"],
        nameEn: jsonMap["nameEn"],
        maintenanceCategoryId: jsonMap["maintenanceCategoryId"]);
  }
}
