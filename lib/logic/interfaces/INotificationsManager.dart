import 'package:e3tmed/models/notification.dart';

// Index order must stay aligned with the backend Models.DataModels.NotificationType enum.
enum NotificationType {
  agentOrderCanceled,
  userOrderStatusChanged,
  userOrderPriceChanged
}

/// Lifecycle state of the realtime notification connection, exposed so the UI
/// can distinguish "still connecting" from "failed" instead of spinning forever.
enum NotificationConnectionStatus { connecting, connected, error }

abstract class INotificationsManager {
  /// Opens the realtime connection. The access token is read live from [IAuth]
  /// on every (re)negotiation, so this only needs to be called once per session.
  Future initialize();

  /// Re-attempts a failed connection (used by the error/retry UI).
  void retry();

  Future disconnect();
  void dismissNotification(APINotification notification);
  Stream<List<APINotification>> get notificationsStream;
  Stream<NotificationConnectionStatus> get connectionStatus;
}
