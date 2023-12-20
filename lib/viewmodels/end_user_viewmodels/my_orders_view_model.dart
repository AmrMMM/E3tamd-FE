import 'dart:developer';

import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/order.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/myorders/order_details_screen.dart';
import '../baseViewModel.dart';

class MyOrderViewModel extends BaseViewModelWithLogic<ICoreLogic> {
  MyOrderViewModel(BuildContext context) : super(context) {
    _init();
  }

  final _myOrdersList = BehaviorSubject<List<Order>?>.seeded(null);

  Stream<List<Order>?> get myOrdersList => _myOrdersList;

  _init() async {
    _myOrdersList.add(null);
    final res = await logic.getUserOrders();
    res.sort((a, b) => b.addedDate.compareTo(a.addedDate));
    _myOrdersList.add(res);
  }

  navigateToOrderDetails(Order order) {
    //Another callback 34an 7oss bytnak
    Navigator.of(context).pushNamed("/orderDetails",
        arguments: OrderDetailsScreenArgs(
            order: order, deleteCallback: () => _init()));
  }
}
