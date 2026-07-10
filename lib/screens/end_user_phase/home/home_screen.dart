import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/servicebutton/service_button.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/models/category.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../models/user_auth_model.dart';
import '../../../viewmodels/end_user_viewmodels/home_view_model.dart';

class HomeScreen extends ScreenWidget {
  HomeScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  HomeScreenState createState() => HomeScreenState(context);
}

class HomeScreenState extends BaseStateObject<HomeScreen, HomeViewModel> {
  HomeScreenState(BuildContext context) : super(() => HomeViewModel(context));

  final string = Injector.appInstance.get<IStrings>();

  Widget _buildNotificationBell(BuildContext context) {
    return StreamBuilder<int>(
      stream: viewModel.notificationCount,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white),
              onPressed: viewModel.navigateToNotifications,
            ),
            if (count > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  constraints:
                      const BoxConstraints(minWidth: 16, minHeight: 16),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count > 9 ? "9+" : "$count",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(string.getStrings(AllStrings.homeTitle)),
        elevation: 0,
        actions: [
          StreamBuilder<LoginState?>(
            stream: viewModel.loginState,
            builder: (context, snapshot) {
              final isGuest = snapshot.data == LoginState.guest ||
                  snapshot.data == LoginState.unAuthenticated ||
                  snapshot.data == null;
              if (isGuest) {
                return TextButton(
                  onPressed: viewModel.navigateToLogin,
                  child: Text(
                    string.getStrings(AllStrings.loginTitle),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return _buildNotificationBell(context);
            },
          ),
        ],
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Stack(children: [
          Container(
            height: 140,
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
                  child: StreamBuilder<LoginState?>(
                      stream: viewModel.loginState,
                      builder: (context, loginSnapshot) {
                        final isGuest = loginSnapshot.data ==
                                LoginState.guest ||
                            loginSnapshot.data == LoginState.unAuthenticated ||
                            loginSnapshot.data == null;
                        if (isGuest) {
                          return Text(
                            string.getStrings(AllStrings.helloGuestTitle),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          );
                        }
                        return StreamBuilder<UserAuthModel?>(
                            stream: viewModel.userModel,
                            builder: (context, snapshot) {
                              return Text(
                                "${string.getStrings(AllStrings.helloTitle)} ${snapshot.data?.name ?? ""}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold),
                              );
                            });
                      }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    string.getStrings(
                        AllStrings.pleaseChooseTheNeededServiceTitle),
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: StreamBuilder<List<Category>?>(
                        stream: viewModel.servicesList,
                        builder: (context, snapshot) {
                          if (snapshot.data == null) {
                            return const Center(
                              child: MainLoadinIndicatorWidget(),
                            );
                          }
                          return ListView(
                              children: snapshot.data!
                                  .map((e) => ServiceButtonWidget(
                                      title: e.getName(),
                                      category: e,
                                      onTap: () =>
                                          viewModel.navigateToService(e)))
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
