import 'package:e3tmed/models/IModelFactory.dart';
import 'package:injector/injector.dart';

class PriceDTO implements IJsonSerializable {
  double totalItemsPrice;
  double agentVisit;
  double vat;
  double totalPrice;
  double paidAmount;
  List<PriceItemDTO> items;
  PriceDTO(
      {required this.totalItemsPrice,
      required this.agentVisit,
      required this.vat,
      required this.totalPrice,
      required this.items,
      required this.paidAmount});

  @override
  Map<String, dynamic> toJson() => {
        "totalItemsPrice": totalItemsPrice,
        "agentVisit": agentVisit,
        "vat": vat,
        "totalPrice": totalPrice,
        "paidAmount": paidAmount,
        "items": items.map((e) => e.toJson()).toList()
      };
}

class PriceDTOFactory implements IModelFactory<PriceDTO> {
  @override
  PriceDTO fromJson(Map<String, dynamic> jsonMap) {
    var priceItemDtoFactory =
        Injector.appInstance.get<IModelFactory<PriceItemDTO>>();
    return PriceDTO(
        totalItemsPrice: jsonMap["totalItemsPrice"].toDouble(),
        agentVisit: jsonMap["agentVisit"].toDouble(),
        vat: jsonMap["vat"].toDouble(),
        totalPrice: jsonMap["totalPrice"].toDouble(),
        paidAmount: jsonMap["paidAmount"].toDouble(),
        items: jsonMap["items"]
            .map<PriceItemDTO>((e) => priceItemDtoFactory.fromJson(e))
            .toList());
  }
}

class PriceItemDTO implements IJsonSerializable {
  double productPrice;
  double extrasAndServices;
  double totalPrice;
  PriceItemDTO(
      {required this.productPrice,
      required this.extrasAndServices,
      required this.totalPrice});

  @override
  Map<String, dynamic> toJson() => {
        "productPrice": productPrice,
        "extrasAndServices": extrasAndServices,
        "totalPrice": totalPrice
      };
}

class PriceItemDTOFactory implements IModelFactory<PriceItemDTO> {
  @override
  PriceItemDTO fromJson(Map<String, dynamic> jsonMap) {
    return PriceItemDTO(
        productPrice: jsonMap["productPrice"].toDouble(),
        extrasAndServices: jsonMap["extrasAndServices"].toDouble(),
        totalPrice: jsonMap["totalPrice"].toDouble());
  }
}
