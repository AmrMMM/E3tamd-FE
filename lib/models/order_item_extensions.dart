import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';

extension OrderItemDisplay on OrderItem {
  String productDisplayName(IStrings strings) =>
      product?.getProductName() ??
      strings.getStrings(AllStrings.deletedProductTitle);

  String categoryDisplayName(IStrings strings) =>
      product?.getCategoryName() ??
      strings.getStrings(AllStrings.deletedProductTitle);
}
