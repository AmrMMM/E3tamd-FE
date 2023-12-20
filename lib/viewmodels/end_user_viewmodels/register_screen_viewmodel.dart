import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';

class RegisterScreenArgs {
  final String email;
  final String phone;
  final String password;

  RegisterScreenArgs(
      {required this.email, required this.phone, required this.password});
}

class RegisterScreenViewModel
    extends BaseViewModelWithLogicAndArgs<IAuth, RegisterScreenArgs> {
  RegisterScreenViewModel(BuildContext context) : super(context);

  // ignore: non_constant_identifier_names
  void NavigateToCompletePhase(RegisterScreenArgs? args) {
    Navigator.pushNamed(context, '/completeRegister', arguments: args);
  }

  // ignore: non_constant_identifier_names
  void NavigateToRout(String rout) {
    Navigator.popAndPushNamed(context, rout);
  }
}
