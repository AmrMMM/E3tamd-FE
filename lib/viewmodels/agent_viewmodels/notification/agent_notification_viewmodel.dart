import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/models/notification.dart';
import 'package:e3tmed/models/notification_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AgentNotificationViewModel
    extends BaseViewModelWithLogic<INotificationsManager> {
  AgentNotificationViewModel(BuildContext context) : super(context);

  final _loading = BehaviorSubject<bool>.seeded(false);

  Stream<List<APINotification>?> get notificationList =>
      logic.notificationsStream;

  Stream<bool> get loading => _loading;
}
