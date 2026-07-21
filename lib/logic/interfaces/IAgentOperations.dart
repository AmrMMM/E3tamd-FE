import 'dart:typed_data';

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
  /// [imageBytes] is optional; when given it becomes the part's only photo.
  Future<Product?> createSparePart({
    required String nameAr,
    required String nameEn,
    required String descriptionAr,
    required String descriptionEn,
    required double price,
    required int stock,
    Uint8List? imageBytes,
    String? imageMimeType,
  });
}
