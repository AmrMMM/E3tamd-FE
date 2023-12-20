import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../DI.dart';
import '../../main.dart';
import '../../models/user_auth_model.dart';

class SettingsViewModel extends BaseViewModelWithLogic<IAuth> {
  SettingsViewModel(BuildContext context) : super(context);

  Stream<UserAuthModel?> get auth => logic.authData;

  navigateToRout(String rout) {
    Navigator.pushNamed(context, rout);
  }

  void logoutUser() async {
    bool? response = await logic.logOut();
    if (response) {
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true)
          .pushNamedAndRemoveUntil("/mainLogin", (route) => false);
    }
  }

  void changeTheCurrentLanguage(Languages language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language.name);
    resetDependencies();
    // ignore: use_build_context_synchronously
    RestartWidget.restartApp(context);
  }
}
