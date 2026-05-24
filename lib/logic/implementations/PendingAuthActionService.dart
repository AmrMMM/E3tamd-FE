import 'package:e3tmed/logic/interfaces/ICart.dart';
import 'package:e3tmed/logic/interfaces/IPendingAuthAction.dart';
import 'package:e3tmed/models/pending_auth_action.dart';
import 'package:e3tmed/screens/end_user_phase/navhost/nav_host_screen.dart';
import 'package:e3tmed/screens/end_user_phase/requesting_item_screen/checkout_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';

import '../interfaces/IStrings.dart';

class PendingAuthActionService implements IPendingAuthAction {
  PendingAuthAction? _pending;

  @override
  PendingAuthAction? get pending => _pending;

  @override
  void setPending(PendingAuthAction? action) {
    _pending = action;
  }

  @override
  void clear() {
    _pending = null;
  }

  @override
  Future<void> executePending(BuildContext context) async {
    final action = _pending;
    if (action == null) return;
    clear();

    final navigator = NavHostScreenState.navigatorKey.currentState;
    if (navigator == null) return;

    final strings = Injector.appInstance.get<IStrings>();
    final cart = Injector.appInstance.get<ICart>();

    switch (action.type) {
      case PendingAuthActionType.addToCart:
        if (action.orderItem != null) {
          final res = await cart.insertItemIntoCartDB(action.orderItem!);
          if (res) {
            Fluttertoast.showToast(
                msg: strings.getStrings(AllStrings.orderAddedToCartTitle),
                gravity: ToastGravity.BOTTOM);
          } else {
            Fluttertoast.showToast(
                msg:
                    strings.getStrings(AllStrings.failedToAddOrderToCartTitle),
                gravity: ToastGravity.BOTTOM);
          }
        }
        break;
      case PendingAuthActionType.checkout:
        if (action.checkoutArgs != null) {
          cart.setCartUsed(false);
          navigator.pushNamed('/checkout', arguments: action.checkoutArgs);
        }
        break;
      case PendingAuthActionType.checkoutAll:
        final items = await cart.getAllItemsFromCartDB();
        if (items.isNotEmpty) {
          cart.setCartUsed(true);
          navigator.pushNamed('/checkout',
              arguments: CheckoutScreenArgs(orderItems: items));
        }
        break;
      case PendingAuthActionType.navigate:
        if (action.routeName != null) {
          navigator.pushNamed(action.routeName!);
        }
        break;
    }
  }
}
