import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/agent_requests_model.dart';

class AgentRequestViewModel extends BaseViewModelWithLogic<IAgentOperations> {
  AgentRequestViewModel(BuildContext context) : super(context) {
    getRequestDataWithFilter(AgentRequestFilters.all);
  }

  final BehaviorSubject<List<AgentRequest>?> requests = BehaviorSubject();
  final BehaviorSubject<String> _string = BehaviorSubject();
  final BehaviorSubject<UserAuthModel?> authData = BehaviorSubject();
  final BehaviorSubject<bool> loadingStream = BehaviorSubject.seeded(false);

  Stream<String> get string => _string;
  Map<AgentRequestFilters, List<AgentRequest>>? itemMap;
  AgentRequestFilters lastFilter = AgentRequestFilters.all;

  getRequestDataWithFilter(AgentRequestFilters filter) async {
    lastFilter = AgentRequestFilters.all;
    itemMap ??= await logic.getUnassignedOrders();
    requests.add(itemMap![filter]!);
  }

  void acceptRequest(AgentRequest request) async {
    loadingStream.add(true);
    var res = await logic.acceptRequest(request);
    loadingStream.add(false);
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      itemMap = null;
      requests.add(null);
      getRequestDataWithFilter(lastFilter);
      Fluttertoast.showToast(
          msg: "Request accepted", gravity: ToastGravity.BOTTOM);
    } else {
      Fluttertoast.showToast(
          msg: "Fail to accept request, please try again",
          gravity: ToastGravity.BOTTOM);
    }
  }
}
