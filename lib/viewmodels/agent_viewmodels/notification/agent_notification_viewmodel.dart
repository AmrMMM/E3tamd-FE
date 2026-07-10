import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/models/IModelFactory.dart';
import 'package:e3tmed/models/notification.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/screens/end_user_phase/myorders/order_details_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AgentNotificationViewModel
    extends BaseViewModelWithLogic<INotificationsManager> {
  AgentNotificationViewModel(BuildContext context) : super(context);

  Stream<List<APINotification>> get notificationList =>
      logic.notificationsStream;

  Stream<NotificationConnectionStatus> get connectionStatus =>
      logic.connectionStatus;

  void retry() => logic.retry();

  void dismiss(APINotification notification) =>
      logic.dismissNotification(notification);

  /// Handles a tap on a notification: marks it as read and, for the client's
  /// order notifications, opens the order (to view status / pay the difference).
  /// The backend has no read/unread state — it only supports dismiss (delete) —
  /// so "mark as read" removes it from the buffer and the unread badge.
  void onNotificationTap(APINotification notification) {
    logic.dismissNotification(notification);
    _openOrder(notification);
  }

  void _openOrder(APINotification notification) {
    Map<String, dynamic>? orderJson;
    switch (notification.type) {
      case NotificationType.userOrderPriceChanged:
        orderJson = notification.object;
        break;
      case NotificationType.userOrderStatusChanged:
        orderJson = notification.object?["order"] as Map<String, dynamic>?;
        break;
      case NotificationType.agentOrderCanceled:
        // Agent-side notification: no client order-details route to open.
        return;
    }
    if (orderJson == null) return;

    final order =
        Injector.appInstance.get<IModelFactory<Order>>().fromJson(orderJson);
    Navigator.of(context).pushNamed("/orderDetails",
        arguments:
            OrderDetailsScreenArgs(order: order, deleteCallback: () {}));
  }
}
