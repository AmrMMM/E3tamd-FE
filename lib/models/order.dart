import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:injector/injector.dart';

import 'agent_requests_model.dart';

class Order implements IJsonSerializable {
  int? id;
  List<OrderItem> items;
  UserAddress address;
  String phoneNumber;
  DateTime addedDate;
  OrderStatus? status;
  double totalPrice;

  Order(
      {required this.items,
      required this.address,
      required this.addedDate,
      required this.phoneNumber,
      required this.totalPrice,
      this.status,
      this.id});

  @override
  Map<String, dynamic> toJson() => {
        "items": items.map((e) => e.toJson()).toList(),
        "addressId": address.id,
        "phoneNumber": phoneNumber,
        if (id != null) "id": id
      };
}

class OrderItemExtraElement implements IJsonSerializable {
  final ExtraModel? extraElement;
  final double? purchasePrice;
  final int extraElementId;
  final int quantity;

  OrderItemExtraElement(
      {this.extraElement,
      this.purchasePrice,
      required this.extraElementId,
      required this.quantity});

  @override
  Map<String, dynamic> toJson() =>
      {"extraElementId": extraElementId, "quantity": quantity};
}

class OrderItemExtraElementFactory
    implements IModelFactory<OrderItemExtraElement> {
  @override
  OrderItemExtraElement fromJson(Map<String, dynamic> jsonMap) {
    final extraElementFactory =
        Injector.appInstance.get<IModelFactory<ExtraModel>>();
    return OrderItemExtraElement(
        extraElement: jsonMap["extraElement"] == null
            ? null
            : extraElementFactory.fromJson(jsonMap["extraElement"]),
        purchasePrice: jsonMap["purchasePrice"]?.toDouble(),
        extraElementId: jsonMap["extraElementId"],
        quantity: jsonMap["quantity"]);
  }
}

class OrderItemExtraProduct implements IJsonSerializable {
  final Product? product;
  final int productId;
  final double? purchasePrice;
  final int quantity;

  OrderItemExtraProduct(
      {this.product,
      required this.productId,
      this.purchasePrice,
      required this.quantity});

  @override
  Map<String, dynamic> toJson() =>
      {"quantity": quantity, "productId": productId};
}

class OrderItemExtraProductFactory
    implements IModelFactory<OrderItemExtraProduct> {
  @override
  OrderItemExtraProduct fromJson(Map<String, dynamic> jsonMap) {
    final productFactory = Injector.appInstance.get<IModelFactory<Product>>();
    return OrderItemExtraProduct(
        product: productFactory.fromJson(jsonMap["product"]),
        productId: jsonMap["productId"],
        purchasePrice: jsonMap["purchasePrice"].toDouble(),
        quantity: jsonMap["quantity"]);
  }
}

class OrderItem implements IJsonSerializable {
  int? id;
  Product product;
  Motor? motor;
  String? dimension;
  String? thickness;
  String? color;
  double? totalPrice;
  double? priceWithoutExtras;
  bool isAgent;
  String? additionalNotes;
  bool maintenance;
  List<OrderItemExtraElement> extras;
  List<OrderItemExtraProduct>? extraProducts;
  List<OrderItemImage>? images;
  int quantity;

  OrderItem(
      {this.id,
      required this.product,
      required this.motor,
      required this.dimension,
      required this.thickness,
      required this.color,
      required this.totalPrice,
      required this.priceWithoutExtras,
      required this.isAgent,
      required this.additionalNotes,
      required this.maintenance,
      required this.extras,
      required this.quantity,
      required this.images,
      this.extraProducts});

  @override
  Map<String, dynamic> toJson() => {
        if (id != null) "id": id,
        "productId": product.id,
        "motorId": motor?.id,
        "dimension": dimension,
        "thickness": thickness,
        "color": color,
        "isAgent": isAgent,
        "maintenance": maintenance,
        "additionalNotes": additionalNotes,
        "extras": extras.map((e) => e.toJson()).toList(),
        "quantity": quantity,
        "Images": images?.map((e) => e.toJson()).toList() ?? [],
        "extraProducts": extraProducts?.map((e) => e.toJson()).toList() ?? []
      };
}

class OrderItemFactory implements IModelFactory<OrderItem> {
  @override
  OrderItem fromJson(Map<String, dynamic> jsonMap) {
    final productFactory = Injector.appInstance.get<IModelFactory<Product>>();
    final motorFactory = Injector.appInstance.get<IModelFactory<Motor>>();
    final extrasFactory =
        Injector.appInstance.get<IModelFactory<OrderItemExtraElement>>();
    final orderExtraProductFactory =
        Injector.appInstance.get<IModelFactory<OrderItemExtraProduct>>();
    final orderItemImageFactory =
        Injector.appInstance.get<IModelFactory<OrderItemImage>>();

    return OrderItem(
        id: jsonMap["id"],
        product: productFactory.fromJson(jsonMap["product"]),
        motor: jsonMap["motor"] == null
            ? null
            : motorFactory.fromJson(jsonMap["motor"]),
        dimension: jsonMap["dimension"],
        thickness: jsonMap["thickness"],
        isAgent: jsonMap["isAgent"],
        color: jsonMap["color"],
        totalPrice: jsonMap["totalPrice"]?.toDouble(),
        priceWithoutExtras: jsonMap["priceWithoutExtras"]?.toDouble(),
        additionalNotes: jsonMap["additionalNotes"],
        maintenance: jsonMap["maintenance"],
        extras: jsonMap["extras"]
            .map<OrderItemExtraElement>((u) => extrasFactory.fromJson(u))
            .toList(),
        quantity: jsonMap["quantity"],
        extraProducts: jsonMap["extraProducts"]
                ?.map<OrderItemExtraProduct>(
                    (e) => orderExtraProductFactory.fromJson(e))
                .toList() ??
            [],
        images: jsonMap["images"]
                ?.map<OrderItemImage>((e) => orderItemImageFactory.fromJson(e))
                .toList() ??
            []);
  }
}

class OrderItemImage implements IJsonSerializable {
  final String data;

  OrderItemImage({required this.data});

  @override
  Map<String, dynamic> toJson() => {"data": data};
}

class OrderItemImageFactory implements IModelFactory<OrderItemImage> {
  @override
  OrderItemImage fromJson(Map<String, dynamic> jsonMap) {
    return OrderItemImage(data: jsonMap["data"]);
  }
}

class OrderFactory implements IModelFactory<Order> {
  @override
  Order fromJson(Map<String, dynamic> jsonMap) {
    final orderItemFactory =
        Injector.appInstance.get<IModelFactory<OrderItem>>();
    final addressFactory =
        Injector.appInstance.get<IModelFactory<UserAddress>>();
    final statusValue = jsonMap["status"] as int?;
    final status = statusValue != null &&
            statusValue >= 0 &&
            statusValue < OrderStatus.values.length
        ? OrderStatus.values[statusValue]
        : null;
    return Order(
        address: addressFactory.fromJson(jsonMap["address"]),
        phoneNumber: jsonMap["phoneNumber"],
        addedDate: DateTime.parse(jsonMap["addedDate"]),
        items: jsonMap["items"]
            .map<OrderItem>((u) => orderItemFactory.fromJson(u))
            .toList(),
        status: status,
        id: jsonMap["id"],
        totalPrice: jsonMap["totalPrice"].toDouble());
  }
}
