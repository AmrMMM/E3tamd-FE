import 'package:e3tmed/logic/interfaces/IAuth.dart';
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

  Stream<UserAuthModel?> get userModel => authLogic.authData;

  Stream<List<Category>?> get servicesList => _servicesList.stream;

  _init() async {
    _rawServiceList = await logic.getRootCategories();
    _servicesList.add(_rawServiceList);
  }

  navigateToService(Category category) {
    Category targetCategory;
    if (category.maintenanceCategoryId != null) {
      targetCategory = _rawServiceList!.firstWhere(
          (element) => element.id == category.maintenanceCategoryId);
      targetCategory.nameAr = category.nameAr;
      targetCategory.nameEn = category.nameEn;
    } else {
      targetCategory = category;
    }
    Navigator.of(context).pushNamed("/newDoors",
        arguments: ProductListScreenArgs(
            category: targetCategory,
            maintenanceMode: category.maintenanceCategoryId != null));
  }
}
