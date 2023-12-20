import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/logic/interfaces/ISocial.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../../screens/agent_phase/order/agent_order_status.dart';

class AgentOrderStatusViewModel extends BaseViewModelWithLogicAndArgs<
    IAgentOperations, AgentOrderStatusScreenArgs> {
  AgentOrderStatusViewModel(BuildContext context) : super(context);

  @override
  void onArgsPushed() {
    calculateTotalPriceDetails();
  }

  final _social = Injector.appInstance.get<ISocial>();
  final _loading = BehaviorSubject<bool>();
  final BehaviorSubject<double> _totalPriceDetails = BehaviorSubject.seeded(0);

  Stream<double> get totalPriceDetails => _totalPriceDetails;

  Stream<bool> get loading => _loading;
  final double vat = 115;

  calculateTotalPriceDetails() async {
    double currentMoney = args!.request.items
        .map((e) => e.totalPrice ?? 0)
        .reduce((value, element) => value + element);
    double extraPrice = 0;
    final allExtrasPrice = args!.request.items
        .expand((e) => e.extras)
        .map((e) => e.extraElement?.price ?? 0);
    if (allExtrasPrice.isNotEmpty) {
      extraPrice = allExtrasPrice.reduce((value, element) => value + element);
    }
    _totalPriceDetails.add(currentMoney + extraPrice + vat);
  }

  void completeCurrentOrder(AgentRequest request) async {
    _loading.add(true);
    var res = await logic.completeOrder(request);
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      args!.onCompleteCallBack();
    } else {}
    _loading.add(false);
  }

  callThisNumber(String phoneNumber) async {
    await _social.contactWithPhoneNumber(phoneNumber);
  }
}
