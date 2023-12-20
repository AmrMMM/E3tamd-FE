import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class AgentViewModel extends BaseViewModelWithLogic<IAuth> {
  AgentViewModel(BuildContext context) : super(context);

  final BehaviorSubject<bool?> _loading = BehaviorSubject.seeded(null);
  final BehaviorSubject<bool?> _isLoginErrd = BehaviorSubject.seeded(null);

  Stream<bool?> get loading => _loading;

  Stream<bool?> get isLoginErrd => _isLoginErrd;

  Future<void> loginWithPhoneAndPassword(String phone, String password) async {
    _loading.add(true);
    _isLoginErrd.add(null);
    final response = await logic.login(phone, password);
    if (response) {
      // ignore: use_build_context_synchronously
      Navigator.popAndPushNamed(context, '/aHomeScreen');
      _isLoginErrd.add(response);
    } else {
      _isLoginErrd.add(response);
    }
    _loading.add(false);
  }
}
