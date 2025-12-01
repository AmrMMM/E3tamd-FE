import 'package:e3tmed/models/AuthModels.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:injector/injector.dart';

import '../DI.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';
import 'IModelFactory.dart';
import 'order.dart';

enum OrderStatus { unassigned, pending, confirmed, toBeDelivered, finished, aWaitingForConfirmation }

class AgentRequest implements IJsonSerializable {
  int id;
  List<OrderItem> items;
  UserAddress address;
  UserInfo user;
  String phoneNumber;
  OrderStatus status;
  DateTime addedDate;

  AgentRequest({
    required this.id,
    required this.items,
    required this.address,
    required this.addedDate,
    required this.user,
    required this.status,
    required this.phoneNumber,
  });

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "items": items.map((e) => e.toJson()).toList(),
        "address": address.toJson(),
        "phoneNumber": phoneNumber,
        "authData": user,
        "addedDate": addedDate.toUtc().toString(),
        "status": status.index
      };
}

class AgentRequestFactory implements IModelFactory<AgentRequest> {
  @override
  AgentRequest fromJson(Map<String, dynamic> jsonMap) {
    final orderItemFactory =
        Injector.appInstance.get<IModelFactory<OrderItem>>();
    final addressFactory =
        Injector.appInstance.get<IModelFactory<UserAddress>>();
    final userFactory = Injector.appInstance.get<IModelFactory<UserInfo>>();
    return AgentRequest(
        id: jsonMap["id"],
        address: addressFactory.fromJson(jsonMap["address"]),
        phoneNumber: jsonMap["phoneNumber"],
        user: userFactory.fromJson(jsonMap["user"]),
        addedDate: DateTime.parse(jsonMap["addedDate"]),
        status: OrderStatus.values[jsonMap["status"]],
        items: jsonMap["items"]
                ?.map<OrderItem>((u) => orderItemFactory.fromJson(u))
                .toList() ??
            []);
  }
}

// class RequestItem implements IJsonSerializable {
//   int id;
//   Product product;
//   Motor? motor;
//   String? dimension;
//   String? thickness;
//   String? color;
//   double? totalPrice;
//   bool isAgent;
//   String? additionalNotes;
//   bool maintenance;
//   List<OrderItemExtraElement> extras;
//   List<String>? images;
//   int quantity;
//
//   RequestItem(
//       {required this.id,
//       required this.product,
//       required this.motor,
//       required this.dimension,
//       required this.thickness,
//       required this.color,
//       required this.totalPrice,
//       required this.isAgent,
//       required this.additionalNotes,
//       required this.maintenance,
//       required this.extras,
//       required this.quantity,
//       required this.images});
//
//   @override
//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "motorId": motor?.id,
//         "dimension": dimension,
//         "thickness": thickness,
//         "color": color,
//         "totalPrice": totalPrice,
//         "extras": extras.map((e) => e.toJson()).toList()
//       };
// }
//
// class RequestItemFactory implements IModelFactory<RequestItem> {
//   @override
//   RequestItem fromJson(Map<String, dynamic> jsonMap) {
//     final productFactory = Injector.appInstance.get<IModelFactory<Product>>();
//     final motorFactory = Injector.appInstance.get<IModelFactory<Motor>>();
//     final extrasFactory =
//         Injector.appInstance.get<IModelFactory<OrderItemExtraElement>>();
//     return RequestItem(
//         id: jsonMap["id"],
//         product: productFactory.fromJson(jsonMap["product"]),
//         motor: jsonMap["motor"] == null
//             ? null
//             : motorFactory.fromJson(jsonMap["motor"]),
//         dimension: jsonMap["dimension"],
//         thickness: jsonMap["thickness"],
//         isAgent: jsonMap["isAgent"],
//         color: jsonMap["color"],
//         totalPrice: jsonMap["totalPrice"].toDouble(),
//         additionalNotes: jsonMap["additionalNotes"],
//         maintenance: jsonMap["maintenance"],
//         extras: jsonMap["extras"]
//             .map<OrderItemExtraElement>((u) => extrasFactory.fromJson(u))
//             .toList(),
//         quantity: jsonMap["quantity"],
//         images: jsonMap["images"]?.cast<String>() ?? []);
//   }
// }

class ExtraModel implements IJsonSerializable {
  final int id;
  final double price;
  final String nameAr;
  final String nameEn;
  final int stock;

  ExtraModel(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.price,
      required this.stock});

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "nameAr": nameAr,
        "nameEn": nameEn,
        "price": price,
        "stock": stock
      };

  String getName() {
    if (useLanguage == Languages.arabic.name) {
      return nameAr;
    } else {
      return nameEn;
    }
  }
}

class ExtraModelFactory implements IModelFactory<ExtraModel> {
  @override
  ExtraModel fromJson(Map<String, dynamic> jsonMap) => ExtraModel(
      id: jsonMap["id"],
      nameAr: jsonMap["nameAr"],
      nameEn: jsonMap["nameEn"],
      price: jsonMap["price"].toDouble(),
      stock: jsonMap["stock"]);
}
