import 'package:e3tmed/models/IModelFactory.dart';

import '../DI.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';

class Offer implements IJsonSerializable {
  final int id;
  final String messageAr;
  final String messageEn;
  final DateTime validTill;
  final String productNameAr;
  final String productNameEn;
  final String categoryNameAr;
  final String categoryNameEn;
  final String manufacturerNameAr;
  final String manufacturerNameEn;

  Offer(
      {required this.id,
      required this.messageAr,
      required this.messageEn,
      required this.validTill,
      required this.productNameAr,
      required this.productNameEn,
      required this.categoryNameAr,
      required this.categoryNameEn,
      required this.manufacturerNameAr,
      required this.manufacturerNameEn});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "messageAr": messageAr,
        "messageEn": messageEn,
        "validTill": validTill.toUtc().toString(),
        "productNameAr": productNameAr,
        "productNameEn": productNameEn,
        "categoryNameAr": categoryNameAr,
        "categoryNameEn": categoryNameEn,
        "manufacturerNameAr": manufacturerNameAr,
        "manufacturerNameEn": manufacturerNameEn
      };

  String getProductName() {
    if (useLanguage == Languages.arabic.name) {
      return productNameAr;
    } else {
      return productNameEn;
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

  String getMessageName() {
    if (useLanguage == Languages.arabic.name) {
      return messageAr;
    } else {
      return messageEn;
    }
  }
}

class OfferFactory implements IModelFactory<Offer> {
  @override
  Offer fromJson(Map<String, dynamic> jsonMap) {
    return Offer(
        id: jsonMap["id"],
        messageAr: jsonMap["messageAr"],
        messageEn: jsonMap["messageEn"],
        validTill: DateTime.parse(jsonMap["validTill"]),
        productNameAr: jsonMap["productNameAr"],
        productNameEn: jsonMap["productNameEn"],
        categoryNameAr: jsonMap["categoryNameAr"],
        categoryNameEn: jsonMap["categoryNameEn"],
        manufacturerNameAr: jsonMap["manufacturerNameAr"],
        manufacturerNameEn: jsonMap["manufacturerNameEn"]);
  }
}
