import 'dart:async';

import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class MainLoginScreenViewModel extends BaseViewModelWithLogic<IAuth> {
  MainLoginScreenViewModel(BuildContext context) : super(context);

  late StreamSubscription _sub;

  final BehaviorSubject<bool?> _loading = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool?> _isLoginErrd = BehaviorSubject.seeded(null);

  Stream<bool?> get loading => _loading;

  Stream<bool?> get isLoginErrd => _isLoginErrd;

  Future<void> loginWithPhoneAndPassword(String phone, String password) async {
    _loading.add(true);
    await logic.login(phone, password);
    _loading.add(false);
    _sub = logic.loggedInStream.listen((val) {
      switch (val) {
        case null:
          _isLoginErrd.add(true);
          break;
        case LoginState.unAuthenticated:
          _isLoginErrd.add(true);
          break;
        case LoginState.agent:
          Navigator.of(context).popAndPushNamed("/aHomeScreen");
          break;
        case LoginState.user:
          Navigator.popAndPushNamed(context, '/home');
          break;
      }
    });
  }

  void navigateToRegisterScreen() {
    Navigator.pushNamed(context, '/register');
  }
}
