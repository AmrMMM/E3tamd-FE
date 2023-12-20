import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AgentForgotPasswordViewModel extends BaseViewModelWithLogic<IAuth> {
  AgentForgotPasswordViewModel(BuildContext context) : super(context);
  final BehaviorSubject<int> _secondsDelay = BehaviorSubject.seeded(60);
  final BehaviorSubject<bool> _loading = BehaviorSubject();
  final BehaviorSubject<bool> _isChangingPassword =
      BehaviorSubject.seeded(false);

  final BehaviorSubject<bool> _isPasswordChanged =
      BehaviorSubject.seeded(false);

  Stream<bool> get loading => _loading;

  Stream<bool> get isChangingPassword => _isChangingPassword;

  Stream<bool> get isPasswordChanged => _isPasswordChanged;

  Stream<int> get secondsDelay => _secondsDelay;

  initViewModel() async {
    var second = 60;
    for (int i = 0; i < 60; i++) {
      await Future.delayed(const Duration(milliseconds: 1000));
      if (second == 0) {
      } else {
        second--;
        _secondsDelay.add(second);
      }
    }
  }

  confirmChangePassword(String code, String newPassword) async {
    _loading.add(true);
    _isPasswordChanged
        .add(await logic.continueForgetPassword(code, newPassword));
    _loading.add(false);
  }

  verifyPhoneNumber(String? phoneNumber) async {
    _loading.add(true);
    _isChangingPassword.add(await logic.forgetPassword(phoneNumber!));
    if (_isChangingPassword.value) {
      initViewModel();
    }
    _loading.add(false);
  }
}
