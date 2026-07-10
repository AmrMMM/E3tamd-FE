import 'package:e3tmed/common/auth/auth_guard.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/INotificationsManager.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/category.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/home/product_list_screen.dart';

class HomeViewModel extends BaseViewModelWithLogic<ICoreLogic> {
  HomeViewModel(BuildContext context) : super(context) {
    _init();
  }

  List<Category>? _rawServiceList;
  final _servicesList = BehaviorSubject<List<Category>?>.seeded(null);
  final authLogic = Injector.appInstance.get<IAuth>();
  final notificationsManager =
      Injector.appInstance.get<INotificationsManager>();

  Stream<UserAuthModel?> get userModel => authLogic.authData;

  Stream<LoginState?> get loginState => authLogic.loggedInStream;

  bool get isGuest => authLogic.isGuest;

  Stream<List<Category>?> get servicesList => _servicesList.stream;

  Stream<int> get notificationCount =>
      notificationsManager.notificationsStream.map((list) => list.length);

  void navigateToNotifications() {
    Navigator.of(context).pushNamed("/notifications");
  }

  _init() async {
    _rawServiceList = await logic.getRootCategories();
    _servicesList.add(_rawServiceList);
  }

  void navigateToLogin() {
    AuthGuard.navigateToLogin(context);
  }

  navigateToService(Category category) {
    Category targetCategory;
    if (category.maintenanceCategoryId != null) {
      final maintenanceCategory = _rawServiceList!.firstWhere(
          (element) => element.id == category.maintenanceCategoryId);
      // Build a fresh Category instead of mutating the shared one from the home
      // list: the maintenance products are fetched by the maintenance category's
      // id, but shown under the clicked category's name. Mutating the shared
      // object renamed the maintenance category on the home grid until a refetch.
      targetCategory = Category(
          id: maintenanceCategory.id,
          maintenanceCategoryId: maintenanceCategory.maintenanceCategoryId,
          nameAr: category.nameAr,
          nameEn: category.nameEn);
    } else {
      targetCategory = category;
    }
    Navigator.of(context).pushNamed("/newDoors",
        arguments: ProductListScreenArgs(
            category: targetCategory,
            maintenanceMode: category.maintenanceCategoryId != null));
  }
}
