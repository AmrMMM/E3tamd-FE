// ignore_for_file: use_build_context_synchronously

import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/auth/verify_username_screen.dart';

class VerifyUsernameViewModel
    extends BaseViewModelWithLogicAndArgs<IAuth, VerifyUsernameArgs> {
  VerifyUsernameViewModel(BuildContext context) : super(context);

  final BehaviorSubject<int> _secondsDelay = BehaviorSubject.seeded(60);
  final BehaviorSubject<bool> _loading = BehaviorSubject();
  final strings = Injector.appInstance.get<IStrings>();

  Stream<bool> get loading => _loading;

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

  verifyUsername(String code) async {
    _loading.add(true);
    final response = await logic.verifyUsername(code, args?.isRegister ?? true);
    if (response) {
      if (args?.isRegister ?? true) {
        Fluttertoast.showToast(
            msg: strings
                .getStrings(AllStrings.registerSuccessfulPleaseLoginTitle));
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      } else {
        Fluttertoast.showToast(
            msg:
                "${currentAuthenticationMode == AuthMode.email ? strings.getStrings(AllStrings.emailTitle) : strings.getStrings(AllStrings.phoneNumberTitle)} ${strings.getStrings(AllStrings.changedSuccessfullyTitle)}");
        Navigator.of(context).pop();
      }
    } else {}
    _loading.add(false);
  }
}
