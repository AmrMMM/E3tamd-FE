import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/price.dart';

abstract class IPriceLogic {
  Future<PriceDTO?> calculatePriceForId(int orderId);
  Future<PriceDTO?> calculatePriceForOrder(List<OrderItem> order);
}
