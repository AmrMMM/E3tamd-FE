import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/models/agent_category.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/home/agent_home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/custom_agent_service_card/agent_service_card.dart';
import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../models/user_auth_model.dart';

class AgentHomeScreen extends ScreenWidget {
  AgentHomeScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  AgentHomeScreenState createState() => AgentHomeScreenState(context);
}

class AgentHomeScreenState
    extends BaseStateObject<AgentHomeScreen, AgentHomeViewModel> {
  AgentHomeScreenState(BuildContext context)
      : super(() => AgentHomeViewModel(context));
  final string = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(string.getStrings(AllStrings.homeTitle)),
        elevation: 0,
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Stack(children: [
          Container(
            height: 100,
            color: Theme.of(context).primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: StreamBuilder<UserAuthModel?>(
                      stream: viewModel.userModel,
                      builder: (context, snapshot) {
                        return Text(
                          "${string.getStrings(AllStrings.helloTitle)} ${snapshot.data?.name}",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        );
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    string.getStrings(
                        AllStrings.startYourOrdersAndContactWithClientsTitle),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: StreamBuilder<List<AgentCategory>?>(
                        stream: viewModel.servicesList,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: MainLoadinIndicatorWidget(),
                            );
                          }
                          return GridView.count(
                              crossAxisCount: 2,
                              children: snapshot.data!
                                  .map((e) => AgentCategoryWidget(
                                        title: e.getName(),
                                        iconData: e.iconData,
                                        onTap: () =>
                                            viewModel.navigateToService(e),
                                        category: e,
                                      ))
                                  .toList());
                        }),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
