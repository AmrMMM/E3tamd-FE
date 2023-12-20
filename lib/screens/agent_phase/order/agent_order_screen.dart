import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/order/agent_order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/agent_request_card/agent_request_card.dart';
import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IAgentOperations.dart';
import '../../../models/agent_requests_model.dart';

class AgentOrderScreen extends ScreenWidget {
  AgentOrderScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  AgentOrderScreenState createState() => AgentOrderScreenState(context);
}

class AgentOrderScreenState
    extends BaseStateObject<AgentOrderScreen, AgentOrderViewModel> {
  AgentOrderScreenState(BuildContext context)
      : super(() => AgentOrderViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(strings.getStrings(AllStrings.myOrdersTitle)),
          elevation: 0,
        ),
        body: Directionality(
          textDirection:
              useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            children: [
              TabBar(
                  unselectedLabelColor: Colors.grey,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  labelColor: Theme.of(context).colorScheme.secondary,
                  onTap: (value) {
                    viewModel.getOrdersDataWithFilter(
                        AgentOrderFilters.values[value]);
                  },
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  tabs: [
                    Tab(
                      text: strings
                          .getOrderFilterString(AgentOrderFilters.pending),
                    ),
                    Tab(
                      text: strings
                          .getOrderFilterString(AgentOrderFilters.confirmed),
                    ),
                    Tab(
                      text: strings
                          .getOrderFilterString(AgentOrderFilters.complete),
                    ),
                  ]),
              Expanded(
                child: StreamBuilder<List<AgentRequest>?>(
                  stream: viewModel.orders,
                  builder: (context, snapshot) => snapshot.data == null
                      ? const Center(
                          child: MainLoadinIndicatorWidget(),
                        )
                      : Center(
                          child: snapshot.data!.isNotEmpty
                              ? ListView(
                                  children: snapshot.data!
                                      .map(
                                        (e) => AgentRequestCardWidget(
                                          onTap: () => viewModel
                                              .navigateToOrderDetails(e),
                                          isOrder: false,
                                          agentRequest: e,
                                          onContactViaWhatsapp:
                                              (request) async {
                                            viewModel.contactViaWhatsapp(
                                                request.phoneNumber);
                                          },
                                        ),
                                      )
                                      .toList(),
                                )
                              : Text(strings
                                  .getStrings(AllStrings.yourListIsEmptyTitle)),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
