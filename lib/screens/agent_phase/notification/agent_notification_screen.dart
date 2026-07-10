import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/models/notification.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/notification/agent_notification_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/agent_notification_card/agent_notification_card.dart';
import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IStrings.dart';

/// Shared notification screen for both agents and clients. The manager decides,
/// from the logged-in role, which notification type it subscribes to.
class AgentNotificationScreen extends ScreenWidget {
  AgentNotificationScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  AgentNotificationScreenState createState() => AgentNotificationScreenState(context);
}

class AgentNotificationScreenState extends BaseStateObject<
    AgentNotificationScreen, AgentNotificationViewModel> {
  AgentNotificationScreenState(BuildContext context)
      : super(() => AgentNotificationViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.notificationTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: StreamBuilder<NotificationConnectionStatus>(
          stream: viewModel.connectionStatus,
          builder: (context, statusSnapshot) {
            final status = statusSnapshot.data;
            return StreamBuilder<List<APINotification>>(
              stream: viewModel.notificationList,
              builder: (context, snapshot) {
                final notifications = snapshot.data ?? [];

                if (notifications.isEmpty) {
                  if (status == NotificationConnectionStatus.error) {
                    return _buildError(context);
                  }
                  if (status == NotificationConnectionStatus.connecting) {
                    return const Center(child: MainLoadinIndicatorWidget());
                  }
                  return _buildEmpty();
                }

                return ListView(
                  children: notifications
                      .map((e) => Dismissible(
                            key: ValueKey(e.id),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => viewModel.dismiss(e),
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              child: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                            ),
                            child: AgentNotificationCardWidget(
                              title:
                                  strings.getNotificationTypeString(e.type),
                              subtitle: e.body,
                              dateTime: _formatDate(e.date),
                              onTap: () => viewModel.onNotificationTap(e),
                            ),
                          ))
                      .toList(),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.black12,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_outlined,
              size: 35,
              color: Colors.black54,
            ),
          ),
          Text(
            strings.getStrings(AllStrings.youDontHaveNotificationYetTitle),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          )
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_outlined, size: 45, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            strings.getStrings(AllStrings.couldNotLoadNotificationsTitle),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: viewModel.retry,
            child: Text(strings.getStrings(AllStrings.retryTitle)),
          ),
        ],
      ),
    );
  }
}
