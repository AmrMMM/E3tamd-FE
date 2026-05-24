import 'package:e3tmed/common/auth/auth_guard.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/models/pending_auth_action.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../DI.dart';
import '../../main.dart';
import '../../models/user_auth_model.dart';

class SettingsViewModel extends BaseViewModelWithLogic<IAuth> {
  SettingsViewModel(BuildContext context) : super(context);

  static const _protectedRoutes = {
    '/accountInformation',
    '/addresses',
    '/changePassword',
    '/changePhoneNumber',
    '/changeEmail',
  };

  static final Uri _accountDeletionUri =
      Uri.parse("https://eatmed.cloud/data-deletion");


  Stream<UserAuthModel?> get auth => logic.authData;

  bool get isGuest => logic.isGuest;

  void navigateToLogin() {
    AuthGuard.navigateToLogin(context);
  }

  void navigateToRegister() {
    Navigator.of(context, rootNavigator: true).pushNamed('/register');
  }

  navigateToRout(String rout) async {
    if (_protectedRoutes.contains(rout)) {
      if (!await AuthGuard.requireClientLogin(context,
          pending: PendingAuthAction.navigate(rout))) {
        return;
      }
    }
    Navigator.pushNamed(context, rout);
  }

  Future<void> openAccountDeletionPage() async {
    await launchUrl(
      _accountDeletionUri,
      mode: LaunchMode.externalApplication,
    );
  }

  void logoutUser() async {
    bool? response = await logic.logOut();
    if (response) {
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true)
          .pushNamedAndRemoveUntil("/home", (route) => false);
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
