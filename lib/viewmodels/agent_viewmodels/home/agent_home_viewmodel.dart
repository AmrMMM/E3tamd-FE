import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/agent_category.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../../logic/interfaces/IAuth.dart';
import '../../../logic/interfaces/core_logic.dart';
import '../../../models/user_auth_model.dart';

class AgentHomeViewModel extends BaseViewModelWithLogic<ICoreLogic> {
  AgentHomeViewModel(BuildContext context) : super(context) {
    init();
  }

  final _servicesList = BehaviorSubject<List<AgentCategory>>();
  final authLogic = Injector.appInstance.get<IAuth>();
  final _strings = Injector.appInstance.get<IStrings>();

  Stream<UserAuthModel?> get userModel => authLogic.authData;

  Stream<List<AgentCategory>?> get servicesList => _servicesList;

  init() {
    _servicesList.add([
      AgentCategory(
          id: 0,
          nameEn: _strings.getStrings(AllStrings.requestsTitle),
          nameAr: _strings.getStrings(AllStrings.requestsTitle),
          iconData: Icons.content_paste),
      AgentCategory(
          id: 1,
          nameEn: _strings.getStrings(AllStrings.myOrdersTitle),
          nameAr: _strings.getStrings(AllStrings.myOrdersTitle),
          iconData: Icons.list),
      AgentCategory(
          id: 2,
          nameEn: _strings.getStrings(AllStrings.notificationTitle),
          nameAr: _strings.getStrings(AllStrings.notificationTitle),
          iconData: Icons.notifications_none),
      AgentCategory(
          id: 3,
          nameEn: _strings.getStrings(AllStrings.profileTitle),
          nameAr: _strings.getStrings(AllStrings.profileTitle),
          iconData: Icons.person_outlined),
    ]);
  }

  navigateToService(AgentCategory category) {
    switch (category.id) {
      case 0:
        return {
          Navigator.of(context).pushNamed(
            "/aRequestScreen",
          )
        };
      case 1:
        return {
          Navigator.of(context).pushNamed(
            "/aOrderScreen",
          )
        };
      case 2:
        return {
          Navigator.of(context).pushNamed(
            "/aNotificationScreen",
          )
        };
      case 3:
        return {
          Navigator.of(context).pushNamed(
            "/aProfileScreen",
          )
        };
    }
  }
}
