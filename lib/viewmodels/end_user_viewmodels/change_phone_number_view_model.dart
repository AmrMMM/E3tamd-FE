import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/auth/verify_username_screen.dart';

class ChangePhoneNumberViewModel extends BaseViewModelWithLogic<IAuth> {
  ChangePhoneNumberViewModel(BuildContext context) : super(context);
  final _userPassword = BehaviorSubject<bool>();
  final _loading = BehaviorSubject<bool?>.seeded(null);

  Stream<UserAuthModel?> get auth => logic.authData;

  Stream<bool> get userPassword => _userPassword;

  Stream<bool?> get loading => _loading;

  void updatePhoneNumber(String newPhoneNumber) async {
    _loading.add(true);
    final res = await logic.updatePhoneNumber(newPhoneNumber);
    if (res && currentAuthenticationMode == AuthMode.phoneNumber) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).popAndPushNamed("/verifyUsername",
          arguments: VerifyUsernameArgs(isRegister: false));
      return;
    }
    _userPassword.add(res);
    _loading.add(null);
  }
}
