import 'dart:async';

import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IConfiguration.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

class SplashScreenViewModel extends BaseViewModelWithLogic<IAuth> {
  SplashScreenViewModel(BuildContext context) : super(context);

  final versionConfig = Injector.appInstance.get<IConfiguration>();
  final _isNewVersion = BehaviorSubject.seeded(false);

  Stream<bool> get isNewVersion => _isNewVersion;

  StreamSubscription? _sub;

  navigate(LoginState state) async {
    final nav = Navigator.of(context);
    final latestVersion = await versionConfig.getCurrentVersion();
    final packageInfo = await PackageInfo.fromPlatform();
    final isUpdateAvailable = _isRemoteVersionNewer(
        latestVersion, packageInfo.version, packageInfo.buildNumber);

    if (!isUpdateAvailable) {
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
          // nav.popAndPushNamed("/aHomeScreen");
          break;
      }
    } else {
      _isNewVersion.add(true);
    }
  }

  bool _isRemoteVersionNewer(
      String remoteVersion, String currentVersion, String currentBuildNumber) {
    final remote = _AppVersion.tryParse(remoteVersion);
    final current = _AppVersion.tryParse('$currentVersion+$currentBuildNumber');
    if (remote == null || current == null) return false;

    return remote.compareTo(current) > 0;
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
    _isNewVersion.close();
  }
}

class _AppVersion implements Comparable<_AppVersion> {
  _AppVersion(this.versionParts, this.buildNumber);

  final List<int> versionParts;
  final int? buildNumber;

  static _AppVersion? tryParse(String value) {
    final match =
        RegExp(r'(\d+(?:\.\d+){0,3})(?:\+(\d+))?').firstMatch(value.trim());
    if (match == null) return null;

    final parts =
        match.group(1)!.split('.').map((part) => int.tryParse(part)).toList();
    if (parts.any((part) => part == null)) return null;

    return _AppVersion(parts.map((part) => part!).toList(),
        int.tryParse(match.group(2) ?? ''));
  }

  @override
  int compareTo(_AppVersion other) {
    final maxLength = versionParts.length > other.versionParts.length
        ? versionParts.length
        : other.versionParts.length;

    for (var index = 0; index < maxLength; index++) {
      final currentPart = index < versionParts.length ? versionParts[index] : 0;
      final otherPart =
          index < other.versionParts.length ? other.versionParts[index] : 0;
      if (currentPart != otherPart) return currentPart.compareTo(otherPart);
    }

    final currentBuildNumber = buildNumber;
    final otherBuildNumber = other.buildNumber;
    if (currentBuildNumber == null || otherBuildNumber == null) return 0;

    return currentBuildNumber.compareTo(otherBuildNumber);
  }
}
