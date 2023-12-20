import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/logic/interfaces/ISocial.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../../screens/agent_phase/order/agent_order_summary_screen.dart';

class AgentOrderSummaryViewModel extends BaseViewModelWithLogicAndArgs<
    IAgentOperations, AgentOrderSummaryScreenArgs> {
  AgentOrderSummaryViewModel(BuildContext context) : super(context);

  final _social = Injector.appInstance.get<ISocial>();

  final BehaviorSubject<bool?> _loading = BehaviorSubject();

  Stream<bool?> get loading => _loading;

  confirmOrder(AgentRequest finalOrder) async {
    _loading.add(true);
    var res = await logic.confirmOrder(finalOrder);
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      args!.onComplete();
    }

    _loading.add(false);
  }

  callThisNumber(String phoneNumber) async {
    await _social.contactViaWhatsApp(phoneNumber);
  }
}
