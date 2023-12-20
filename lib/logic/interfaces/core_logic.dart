import 'package:e3tmed/models/category.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/offer.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:flutter/services.dart';

abstract class ICoreLogic {
  Future<List<Offer>> getOffers();

  Future<List<Category>> getRootCategories();

  Future<List<Category>> getChildrenOf(Category category);

  Future<List<Product>> getProductsOf(Category category);

  Future<double> calculatePrice(Product product, String? dimension,
      String? thickness, Motor? motor, List<OrderItemExtraElement> extras);

  Future<Uint8List?> getCategoryImage(Category category);

  Future<Uint8List?> getProductImage(Product product);

  Future<bool> makeOrder(Order order);

  Future<List<Order>> getUserOrders();

  Future<bool> cancelOrder(Order order);
}
