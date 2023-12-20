import 'dart:typed_data';

import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/category.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/offer.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:injector/injector.dart';

class CoreLogic implements ICoreLogic {
  final http = Injector.appInstance.get<IHTTP>();

  @override
  Future<List<Category>> getChildrenOf(Category category) async {
    final res = await http
        .rget<Category>("Category", queryArgs: {"categoryId": category.id});
    if (res.statusCode == 200) {
      return res.body ?? [];
    }
    return [];
  }

  @override
  Future<List<Product>> getProductsOf(Category category) async {
    final res =
        await http.rpost<Product>("Product/InCategory", body: [category.id]);
    if (res.statusCode == 200) {
      return res.body ?? [];
    }
    return [];
  }

  @override
  Future<List<Category>> getRootCategories() async {
    final res = await http.rget<Category>("Category");
    if (res.statusCode == 200) {
      return res.body ?? [];
    }
    return [];
  }

  @override
  Future<Uint8List?> getCategoryImage(Category category) async {
    return await http
        .getBytes("Category/Image", queryArgs: {"categoryId": category.id});
  }

  @override
  Future<Uint8List?> getProductImage(Product product) async {
    return await http
        .getBytes("Product/Image", queryArgs: {"productId": product.id});
  }

  @override
  Future<double> calculatePrice(
      Product product,
      String? dimension,
      String? thickness,
      Motor? motor,
      List<OrderItemExtraElement> extras) async {
    final res = await http.rget("Product/Price",
        queryArgs: !product.withExtraDetails
            ? {"productId": product.id}
            : {
                "dimension": dimension,
                "thickness": thickness,
                "productId": product.id,
                "motorId": motor?.id,
              },
        body: extras.isEmpty ? [] : extras.map((e) => e.toJson()).toList());
    if (res.statusCode == 200) {
      return res.rawBody.toDouble();
    }
    return 0;
  }

  @override
  Future<List<Offer>> getOffers() async {
    final res = await http.rget<Offer>("Product/Offer");
    if (res.statusCode == 200) {
      return res.body ?? [];
    }
    return [];
  }

  @override
  Future<bool> makeOrder(Order order) async {
    final res = await http.post("Product/Order", body: order);
    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Future<List<Order>> getUserOrders() async {
    final res = await http.rget<Order>("Product/Order");
    if (res.statusCode == 200) {
      return res.body ?? [];
    }
    return [];
  }

  @override
  Future<bool> cancelOrder(Order order) async {
    final res =
        await http.delete("Product/Order", queryArgs: {"orderId": order.id});
    return (res.statusCode == 200);
  }
}
