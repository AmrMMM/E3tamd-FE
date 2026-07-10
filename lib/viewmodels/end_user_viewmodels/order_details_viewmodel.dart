import 'package:e3tmed/logic/interfaces/IPriceLogic.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/myorders/order_details_screen.dart';
import '../../screens/end_user_phase/requesting_item_screen/payment_screen.dart';
import '../baseViewModel.dart';

class OrderDetailsViewModel
    extends BaseViewModelWithLogicAndArgs<ICoreLogic, OrderDetailsScreenArgs> {
  OrderDetailsViewModel(BuildContext context) : super(context);
  final BehaviorSubject<bool> _loading = BehaviorSubject();
  final _outstanding = BehaviorSubject<double?>.seeded(null);
  final _order = BehaviorSubject<Order>();
  final strings = Injector.appInstance.get<IStrings>();
  final _priceLogic = Injector.appInstance.get<IPriceLogic>();

  Stream<bool> get loading => _loading;

  /// The current order, re-fetched from the server. The order passed in the
  /// route args can be a STALE snapshot (e.g. when opened from an old
  /// notification, whose embedded order reflects the status at the time the
  /// notification was created — not the order's current status). The screen
  /// uses this stream (with the passed order as immediate `initialData`) so it
  /// always shows the live status.
  Stream<Order> get order => _order;

  /// Amount the client still owes on this order (0 when nothing is due). Drives
  /// the prominent "Pay the difference" button so the client doesn't have to
  /// dig into the details sheet to discover an outstanding balance.
  Stream<double?> get outstanding => _outstanding;

  @override
  void onArgsPushed() {
    _refresh();
  }

  Future<void> _refresh() async {
    final orderId = args!.order.id;
    if (orderId == null) return;

    // Replace the (possibly stale) passed-in order with the live one.
    final fresh = await logic.getOrder(orderId);
    if (fresh != null) _order.add(fresh);

    final price = await _priceLogic.calculatePriceForId(orderId);
    if (price == null) return;
    final due = price.totalPrice - price.paidAmount;
    _outstanding.add(price.paidAmount > 0 && due > 0 ? due : 0);
  }

  /// Opens the difference-payment flow from the main order screen.
  void payDifference(Order order) => _openDifferencePayment(order);

  /// Opens the difference-payment flow from the details bottom sheet, which
  /// must be dismissed first.
  void payDifferenceFromSheet(Order order) {
    Navigator.of(context).pop();
    _openDifferencePayment(order);
  }

  Future<void> _openDifferencePayment(Order order) async {
    final paid = await Navigator.of(context).pushNamed("/payment",
        arguments:
            PaymentScreenArgs(request: order, differenceOrderId: order.id));
    if (paid == true) {
      await _refresh();
    }
  }

  cancelOrder(Order order) async {
    _loading.add(true);
    final res = await logic.cancelOrder(order);
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: strings.getStrings(AllStrings.orderCanceledSuccessfullyTitle),
          gravity: ToastGravity.BOTTOM);
      args!.deleteCallback();
    } else {
      Fluttertoast.showToast(
          msg: strings.getStrings(AllStrings.failedToCancelOrderTitle),
          gravity: ToastGravity.BOTTOM);
    }
    _loading.add(false);
  }

  @override
  void onClose() {
    _loading.close();
    _outstanding.close();
    _order.close();
    super.onClose();
  }
}
