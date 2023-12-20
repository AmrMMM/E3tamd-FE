import 'package:e3tmed/models/notification.dart';

enum NotificationType { agentOrderCanceled, userOrderStatusChanged }

abstract class INotificationsManager {
  Future initialize(String token);
  Future disconnect();
  void dismissNotification(APINotification notification);
  Stream<List<APINotification>?> get notificationsStream;
}
