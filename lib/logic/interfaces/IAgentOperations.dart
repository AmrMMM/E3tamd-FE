import '../../models/agent_requests_model.dart';

enum AgentRequestFilters { all, newOrder, repair }

enum AgentOrderFilters { pending, confirmed, complete }

abstract class IAgentOperations {
  Future<Map<AgentRequestFilters, List<AgentRequest>>?> getUnassignedOrders();

  Future<Map<AgentOrderFilters, List<AgentRequest>>?> getAssignedOrders();

  Future<bool> confirmOrder(AgentRequest order);

  Future<bool> completeOrder(AgentRequest order);

  Future<bool> acceptRequest(AgentRequest request);
}
