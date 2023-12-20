import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';

class LoginSignUpScreenViewModel extends BaseViewModelWithLogic<IAuth> {
  LoginSignUpScreenViewModel(BuildContext context) : super(context);

  navigateToRout(String rout) {
    Navigator.popAndPushNamed(context, rout);
  }
}
