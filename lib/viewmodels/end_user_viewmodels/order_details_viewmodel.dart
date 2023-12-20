import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/myorders/order_details_screen.dart';
import '../baseViewModel.dart';

class OrderDetailsViewModel
    extends BaseViewModelWithLogicAndArgs<ICoreLogic, OrderDetailsScreenArgs> {
  OrderDetailsViewModel(BuildContext context) : super(context);
  final BehaviorSubject<bool> _loading = BehaviorSubject();
  final strings = Injector.appInstance.get<IStrings>();

  Stream<bool> get loading => _loading;

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
}
