import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';

class IntroViewModel extends BaseViewModel {
  IntroViewModel(BuildContext context) : super(context);

  void goToLoginSignUpScreen() {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }
}
