import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AccountInformationViewModel extends BaseViewModelWithLogic<IAuth> {
  AccountInformationViewModel(BuildContext context) : super(context);

  final _userFirstAndLastName = BehaviorSubject<bool>();
  final _loading = BehaviorSubject<bool?>.seeded(null);
  late UserAuthModel _userData;

  Stream<bool> get userFirstAndLastName => _userFirstAndLastName;

  Stream<bool?> get loading => _loading;

  Stream<UserAuthModel?> get userData => logic.authData;

  void updateUserFirstAndLastName(String firstName, String lastName) async {
    _loading.add(true);
    _userFirstAndLastName
        .add(await logic.updateFirstAndLastName(firstName, lastName));
    _loading.add(null);
  }
}
