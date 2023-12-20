import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/models/notification.dart';
import 'package:e3tmed/models/notification_model.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/notification/agent_notification_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/agent_notification_card/agent_notification_card.dart';
import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IStrings.dart';

class AgentNotificationScreen extends ScreenWidget {
  AgentNotificationScreen(BuildContext context) : super(context);

  @override
  AgentNotificationScreenState createState() =>
      AgentNotificationScreenState(context);
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
        child: StreamBuilder<bool>(
          stream: viewModel.loading,
          builder: (context, snapshot) => snapshot.data != null &&
                  !snapshot.data!
              ? StreamBuilder<List<APINotification>?>(
                  stream: viewModel.notificationList,
                  builder: (context, snapshot) => snapshot.data == null
                      ? const Center(child: MainLoadinIndicatorWidget())
                      : snapshot.data!.isNotEmpty
                          ? ListView(
                              children: snapshot.data!
                                  .map((e) => e.type ==
                                          NotificationType.agentOrderCanceled
                                      ? AgentNotificationCardWidget(
                                          title: strings.getStrings(
                                              AllStrings.orderCanceledTitle),
                                          subtitle: e.body,
                                          dateTime: e.date.year.toString(),
                                        )
                                      : const SizedBox())
                                  .toList(),
                            )
                          : Center(
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
                                    strings.getStrings(AllStrings
                                        .youDontHaveNotificationYetTitle),
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                )
              : const Center(
                  child: MainLoadinIndicatorWidget(),
                ),
        ),
      ),
    );
  }
}
