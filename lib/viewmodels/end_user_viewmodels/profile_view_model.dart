import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';

class ProfileViewModel extends BaseViewModelWithLogic<IAuth> {
  ProfileViewModel(BuildContext context) : super(context);

  Stream<UserAuthModel?> get auth => logic.authData;

  navigateToPage(String rout) {
    Navigator.pushNamed(context, rout);
  }
}
