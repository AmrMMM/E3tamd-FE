import 'package:e3tmed/common/auth/auth_guard.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IPendingAuthAction.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

class MainLoginScreenViewModel extends BaseViewModelWithLogic<IAuth> {
  MainLoginScreenViewModel(BuildContext context) : super(context);

  final _pendingService = Injector.appInstance.get<IPendingAuthAction>();

  final BehaviorSubject<bool?> _loading = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool?> _isLoginErrd = BehaviorSubject.seeded(null);

  Stream<bool?> get loading => _loading;

  Stream<bool?> get isLoginErrd => _isLoginErrd;

  Future<void> loginWithPhoneAndPassword(String phone, String password) async {
    _loading.add(true);
    _isLoginErrd.add(null);
    final success = await logic.login(phone, password);
    _loading.add(false);

    if (!success) {
      _isLoginErrd.add(true);
      return;
    }

    await _handleLoginSuccess(logic.isLoggedIn());
  }

  Future<void> _handleLoginSuccess(LoginState? state) async {
    switch (state) {
      case LoginState.agent:
        AuthGuard.clearPending();
        // ignore: use_build_context_synchronously
        Navigator.of(context).popAndPushNamed("/aHomeScreen");
        break;
      case LoginState.user:
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
        if (_pendingService.pending != null) {
          // ignore: use_build_context_synchronously
          await _pendingService.executePending(context);
        }
        break;
      case LoginState.guest:
      case LoginState.unAuthenticated:
      case null:
        _isLoginErrd.add(true);
        break;
    }
  }

  void navigateToRegisterScreen() {
    Navigator.pushNamed(context, '/register');
  }
}
