import '../../models/agent_requests_model.dart';
import '../../models/product.dart';

enum AgentRequestFilters { all, newOrder, repair }

enum AgentOrderFilters { pending, confirmed, complete }

abstract class IAgentOperations {
  Future<Map<AgentRequestFilters, List<AgentRequest>>?> getUnassignedOrders();

  Future<Map<AgentOrderFilters, List<AgentRequest>>?> getAssignedOrders();

  Future<bool> confirmOrder(AgentRequest order);

  Future<bool> completeOrder(AgentRequest order);

  Future<bool> acceptRequest(AgentRequest request);

  /// Creates a new spare part (a product in the spare-parts category) with the
  /// agent-supplied price and returns it so it can be attached to the order.
  Future<Product?> createSparePart({
    required String nameAr,
    required String nameEn,
    required String description,
    required double price,
    required int stock,
  });
}
