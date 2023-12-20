// ignore: file_names
import 'package:e3tmed/models/order.dart';

abstract class ICart {
  Future<bool> insertItemIntoCartDB(OrderItem orderItem);

  Future<bool> deleteItemFromCartDB(OrderItem orderItem);

  Future<List<OrderItem>> getAllItemsFromCartDB();

  void checkoutCallback();
  void setCartUsed(bool isUsed);

  Stream<List<OrderItem>?> get carList;
}
