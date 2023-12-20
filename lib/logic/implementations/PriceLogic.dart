import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/logic/interfaces/IPriceLogic.dart';
import 'package:e3tmed/models/price.dart';
import 'package:e3tmed/models/order.dart';
import 'package:injector/injector.dart';

class PriceLogic implements IPriceLogic {
  final http = Injector.appInstance.get<IHTTP>();

  @override
  Future<PriceDTO?> calculatePriceForId(int orderId) async {
    var res =
        await http.rget<PriceDTO>("Price/old", queryArgs: {"orderId": orderId});
    if (res.statusCode == 200 && res.body != null) {
      return res.body![0];
    }
    return null;
  }

  @override
  Future<PriceDTO?> calculatePriceForOrder(List<OrderItem> order) async {
    var res = await http.rpost<PriceDTO>("Price/new", body: order);
    if (res.statusCode == 200 && res.body != null) {
      return res.body![0];
    }
    return null;
  }
}
