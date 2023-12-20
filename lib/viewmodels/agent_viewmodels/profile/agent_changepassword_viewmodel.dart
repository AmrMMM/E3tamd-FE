import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AgentChangePasswordViewModel extends BaseViewModelWithLogic<IAuth> {
  AgentChangePasswordViewModel(BuildContext context) : super(context);

  final _userPassword = BehaviorSubject<bool?>.seeded(null);
  final _loading = BehaviorSubject<bool?>.seeded(null);

  Stream<bool?> get userPassword => _userPassword;

  Stream<bool?> get loading => _loading;

  void updateUserPassword(String currentPassword, String newPassword) async {
    _loading.add(true);
    _userPassword.add(await logic.updatePassword(currentPassword, newPassword));
    _loading.add(false);
  }
}
