import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../DI.dart';
import '../../../main.dart';
import '../../../models/user_auth_model.dart';
import '../../baseViewModel.dart';

class AgentProfileViewModel extends BaseViewModelWithLogic<IAuth> {
  AgentProfileViewModel(BuildContext context) : super(context);

  Stream<UserAuthModel?> get auth => logic.authData;

  void logoutUser() async {
    var res = await logic.logOut();
    if (res) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, "/mainLogin", (route) => false);
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
