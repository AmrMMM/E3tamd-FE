import 'package:e3tmed/common/auth/auth_guard.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/models/pending_auth_action.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';

class ProfileViewModel extends BaseViewModelWithLogic<IAuth> {
  ProfileViewModel(BuildContext context) : super(context);

  Stream<UserAuthModel?> get auth => logic.authData;

  bool get isGuest => logic.isGuest;

  void navigateToLogin() {
    AuthGuard.navigateToLogin(context);
  }

  void navigateToRegister() {
    Navigator.of(context, rootNavigator: true).pushNamed('/register');
  }

  navigateToPage(String rout) async {
    if (rout == '/offers' || rout == '/myOrders') {
      if (!await AuthGuard.requireClientLogin(context,
          pending: PendingAuthAction.navigate(rout))) {
        return;
      }
    }
    Navigator.pushNamed(context, rout);
  }
}
