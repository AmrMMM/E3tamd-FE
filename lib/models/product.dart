import 'package:e3tmed/DI.dart';
import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:injector/injector.dart';
import 'motor.dart';

class Product implements IJsonSerializable {
  int id;
  String nameAr;
  String nameEn;
  String description;
  DateTime manufactureDate;
  double basePrice;
  String manufacturerNameAr;
  String manufacturerNameEn;
  String categoryNameAr;
  String categoryNameEn;
  List<String>? availableDimensions;
  List<String>? availableThickness;
  List<String>? availableColors;
  bool withExtraDetails;
  List<ExtraModel>? availableExtras;
  List<Motor>? motors;
  int stock;

  Product(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.description,
      required this.manufactureDate,
      required this.basePrice,
      required this.manufacturerNameAr,
      required this.manufacturerNameEn,
      required this.categoryNameAr,
      required this.categoryNameEn,
      required this.withExtraDetails,
      required this.stock,
      this.availableColors,
      this.availableDimensions,
      this.availableThickness,
      this.availableExtras,
      this.motors});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nameAr": nameAr,
        "nameEn": nameEn,
        "description": description,
        "manufactureDate": manufactureDate.toUtc().toString(),
        "basePrice": basePrice,
        "manufacturerNameAr": manufacturerNameAr,
        "manufacturerNameEn": manufacturerNameEn,
        "categoryNameAr": categoryNameAr,
        "categoryNameEn": categoryNameEn,
        "withExtraDetails": withExtraDetails,
        "availableExtras":
            availableExtras?.map((u) => u.toJson()).toList() ?? [],
        "motors": motors?.map((u) => u.toJson()).toList() ?? [],
        "stock": stock
      };

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return (other as Product).id == id;
  }

  @override
  int get hashCode => id;

  String getProductName() {
    if (useLanguage == Languages.arabic.name) {
      return nameAr;
    } else {
      return nameEn;
    }
  }

  String getCategoryName() {
    if (useLanguage == Languages.arabic.name) {
      return categoryNameAr;
    } else {
      return categoryNameEn;
    }
  }

  String getManufacturerName() {
    if (useLanguage == Languages.arabic.name) {
      return manufacturerNameAr;
    } else {
      return manufacturerNameEn;
    }
  }
}

class ProductFactory implements IModelFactory<Product> {
  @override
  Product fromJson(Map<String, dynamic> jsonMap) {
    final productExtraFactory =
        Injector.appInstance.get<IModelFactory<ExtraModel>>();
    final motorFactory = Injector.appInstance.get<IModelFactory<Motor>>();
    return Product(
        id: jsonMap["id"],
        nameAr: jsonMap["nameAr"],
        nameEn: jsonMap["nameEn"],
        stock: jsonMap["stock"],
        description: jsonMap["description"],
        manufactureDate: DateTime.parse(jsonMap["manufactureDate"]),
        basePrice: jsonMap["basePrice"].toDouble(),
        manufacturerNameAr: jsonMap["manufacturerNameAr"],
        manufacturerNameEn: jsonMap["manufacturerNameEn"],
        categoryNameAr: jsonMap["categoryNameAr"],
        categoryNameEn: jsonMap["categoryNameEn"],
        withExtraDetails: jsonMap["withExtraDetails"],
        availableColors: jsonMap["availableColors"]?.cast<String>(),
        availableDimensions: jsonMap["availableDimensions"]?.cast<String>(),
        availableThickness: jsonMap["availableThickness"]?.cast<String>(),
        availableExtras: jsonMap["availableExtras"]
            ?.map<ExtraModel>((u) => productExtraFactory.fromJson(u))
            .toList(),
        motors: jsonMap["motors"]
            ?.map<Motor>((u) => motorFactory.fromJson(u))
            .toList());
  }
}
