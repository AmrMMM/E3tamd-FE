import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/screens/end_user_phase/requesting_item_screen/checkout_screen.dart';

enum PendingAuthActionType { addToCart, checkout, checkoutAll, navigate }

class PendingAuthAction {
  final PendingAuthActionType type;
  final OrderItem? orderItem;
  final CheckoutScreenArgs? checkoutArgs;
  final String? routeName;

  const PendingAuthAction({
    required this.type,
    this.orderItem,
    this.checkoutArgs,
    this.routeName,
  });

  factory PendingAuthAction.addToCart(OrderItem item) => PendingAuthAction(
        type: PendingAuthActionType.addToCart,
        orderItem: item,
      );

  factory PendingAuthAction.checkout(CheckoutScreenArgs args) =>
      PendingAuthAction(
        type: PendingAuthActionType.checkout,
        checkoutArgs: args,
      );

  factory PendingAuthAction.checkoutAll() => const PendingAuthAction(
        type: PendingAuthActionType.checkoutAll,
      );

  factory PendingAuthAction.navigate(String route) => PendingAuthAction(
        type: PendingAuthActionType.navigate,
        routeName: route,
      );
}
