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
        _returnToLogin();
      } else {
        Fluttertoast.showToast(
            msg:
                "${currentAuthenticationMode == AuthMode.email ? strings.getStrings(AllStrings.emailTitle) : strings.getStrings(AllStrings.phoneNumberTitle)} ${strings.getStrings(AllStrings.changedSuccessfullyTitle)}");
        Navigator.of(context).pop();
      }
    } else {}
    _loading.add(false);
  }

  /// Registering does not sign the user in - no token is issued, which is why the toast above asks
  /// them to log in. So this unwinds the registration screens back to the login screen instead of
  /// rebuilding the app at '/home'.
  ///
  /// Rebuilding at '/home' used to destroy the whole root stack, taking NavHostScreen's nested
  /// navigator with it - and with that, the product screen the user was configuring plus any pending
  /// action waiting to resume after authentication.
  void _returnToLogin() {
    // Captured before popping: the NavigatorState outlives this route, whereas `context` does not.
    final navigator = Navigator.of(context);

    // The predicate records what it found on the way down, because once popUntil returns this
    // route is gone and its context can no longer be asked where it landed. `route.isFirst` is the
    // safety net - without it a missing '/mainLogin' would pop until the stack was empty.
    var landedOnLogin = false;
    navigator.popUntil((route) {
      if (route.settings.name == '/mainLogin') {
        landedOnLogin = true;
        return true;
      }
      return route.isFirst;
    });

    // Registration was started somewhere that never went through the login screen - the guest
    // profile/settings cards push '/register' directly - so send them there now.
    if (!landedOnLogin) {
      navigator.pushNamed('/mainLogin');
    }
  }
}
