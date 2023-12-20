import 'package:e3tmed/logic/interfaces/IAgentOperations.dart';
import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:injector/injector.dart';

class AgentRequestImplementation implements IAgentOperations {
  final http = Injector.appInstance.get<IHTTP>();

  @override
  Future<bool> acceptRequest(AgentRequest request) async {
    final res =
        await http.post("Agent/Assign", queryArgs: {"orderId": request.id});
    if (res.statusCode == 200) {
      request.status = OrderStatus.pending;
      return true;
    }
    return false;
  }

  @override
  Future<bool> completeOrder(AgentRequest order) async {
    final res =
        await http.post("Agent/Complete", queryArgs: {"orderId": order.id});
    if (res.statusCode == 200) {
      order.status = OrderStatus.finished;
      return true;
    }
    return false;
  }

  @override
  Future<bool> confirmOrder(AgentRequest order) async {
    final res = await http.post("Agent/Update", body: order);
    if (res.statusCode == 200) {
      order.status = OrderStatus.confirmed;
      return true;
    }
    return false;
  }

  bool checkAgentRequestStatus(AgentRequest item, AgentRequestFilters filter) {
    var state =
        DateTime.now().toUtc().difference(item.addedDate.toUtc()).inDays == 0
            ? AgentRequestFilters.newOrder
            : item.items.indexWhere((x) => x.maintenance) != -1
                ? AgentRequestFilters.repair
                : AgentRequestFilters.all;
    return state == filter;
  }

  bool checkAgentOrderStatus(AgentRequest item, AgentOrderFilters filter) {
    var state = item.status == OrderStatus.pending
        ? AgentOrderFilters.pending
        : item.status == OrderStatus.confirmed
            ? AgentOrderFilters.confirmed
            : AgentOrderFilters.complete;
    return state == filter;
  }

  @override
  Future<Map<AgentOrderFilters, List<AgentRequest>>?>
      getAssignedOrders() async {
    final res = await http.rget<AgentRequest>("Agent/Assigned");
    if (res.statusCode == 200 && res.body != null) {
      return {
        for (var filterValue in AgentOrderFilters.values)
          filterValue: res.body!
              .where((element) => checkAgentOrderStatus(element, filterValue))
              .toList()
      };
    }
    return null;
  }

  @override
  Future<Map<AgentRequestFilters, List<AgentRequest>>?>
      getUnassignedOrders() async {
    final res = await http.rget<AgentRequest>("Agent/Unassigned");
    if (res.statusCode == 200 && res.body != null) {
      return {
        for (var filterValue in AgentRequestFilters.values)
          filterValue: res.body!
              .where((element) => checkAgentRequestStatus(element, filterValue))
              .toList()
      };
    }
    return null;
  }
}
