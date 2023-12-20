import 'dart:async';
import 'dart:io';

import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IConfiguration.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:package_info/package_info.dart';
import 'package:rxdart/rxdart.dart';

class SplashScreenViewModel extends BaseViewModelWithLogic<IAuth> {
  SplashScreenViewModel(BuildContext context) : super(context);

  final versionConfig = Injector.appInstance.get<IConfiguration>();
  final _isNewVersion = BehaviorSubject.seeded(false);

  Stream<bool> get isNewVersion => _isNewVersion;

  StreamSubscription? _sub;

  navigate(LoginState state) async {
    final nav = Navigator.of(context);
    String latestVersion = await versionConfig.getCurrentVersion();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if (latestVersion == version) {
      _isNewVersion.add(false);
      switch (state) {
        case LoginState.unAuthenticated:
          nav.popAndPushNamed("/mainLogin");
          break;
        case LoginState.agent:
          nav.popAndPushNamed("/aHomeScreen");
          break;
        case LoginState.user:
          nav.popAndPushNamed('/home');
          break;
      }
    } else {
      _isNewVersion.add(true);
    }
  }

  splashScreenHandler() async {
    await Future.delayed(const Duration(seconds: 2));
    var currentState = logic.isLoggedIn();
    if (currentState != null) {
      navigate(currentState);
    } else {
      _sub = logic.loggedInStream.listen((val) {
        if (val == null) return;
        navigate(val);
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
    _sub?.cancel();
  }
}
