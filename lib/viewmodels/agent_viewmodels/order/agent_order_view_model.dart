import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/logic/interfaces/ISocial.dart';
import 'package:e3tmed/screens/agent_phase/order/agent_order_details_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/agent_requests_model.dart';
import '../../../screens/agent_phase/order/agent_order_status.dart';

class AgentOrderViewModel extends BaseViewModelWithLogic<IAgentOperations> {
  AgentOrderViewModel(BuildContext context) : super(context) {
    getOrdersDataWithFilter(AgentOrderFilters.pending);
    lastFilter = AgentOrderFilters.pending;
  }

  final social = Injector.appInstance.get<ISocial>();
  final BehaviorSubject<List<AgentRequest>?> _orders = BehaviorSubject();
  final BehaviorSubject<String> _string = BehaviorSubject();

  Stream<String> get string => _string;

  Stream<List<AgentRequest>?> get orders => _orders;

  Map<AgentOrderFilters, List<AgentRequest>>? itemMap;

  late AgentOrderFilters lastFilter;

  getOrdersDataWithFilter(AgentOrderFilters filter) async {
    _orders.add(null);
    itemMap ??= await logic.getAssignedOrders();
    _orders.add(itemMap![filter]!);
    lastFilter = filter;
  }

  navigateToOrderDetails(AgentRequest order) {
    if (order.status != OrderStatus.pending) {
      Navigator.of(context).pushNamed("/aOrderStatusScreen",
          arguments: AgentOrderStatusScreenArgs(
              request: order,
              onCompleteCallBack: () {
                itemMap = null;
                getOrdersDataWithFilter(lastFilter);
              }));
    } else {
      Navigator.of(context).pushNamed("/aOrderDetailsScreen",
          arguments: AgentOrderDetailsScreenArgs(
              request: order,
              callback: () {
                itemMap = null;
                getOrdersDataWithFilter(lastFilter);
              }));
    }
  }

  void contactViaWhatsapp(String phoneNumber) async {
    await social.contactViaWhatsApp(phoneNumber);
  }
}
