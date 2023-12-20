import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/auth/verify_username_screen.dart';

class ChangeEmailViewModel extends BaseViewModelWithLogic<IAuth> {
  ChangeEmailViewModel(BuildContext context) : super(context);

  final _userEmail = BehaviorSubject<bool>();
  final _loading = BehaviorSubject<bool?>.seeded(null);

  Stream<bool> get userEmail => _userEmail;

  Stream<bool?> get loading => _loading;

  void updateUserEmail(String newEmail) async {
    _loading.add(true);
    final res = await logic.updateEmail(newEmail);
    if (res && currentAuthenticationMode == AuthMode.email) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).popAndPushNamed("/verifyUsername",
          arguments: VerifyUsernameArgs(isRegister: false));
      return;
    }
    _userEmail.add(res);
    _loading.add(null);
  }
}
