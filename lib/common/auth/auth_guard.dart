import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IPendingAuthAction.dart';
import 'package:e3tmed/models/pending_auth_action.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AuthGuard {
  static final _auth = Injector.appInstance.get<IAuth>();
  static final _pendingService = Injector.appInstance.get<IPendingAuthAction>();

  static bool get isClientLoggedIn => _auth.isClient;

  static Future<bool> requireClientLogin(
    BuildContext context, {
    PendingAuthAction? pending,
  }) async {
    if (_auth.isClient) return true;
    navigateToLogin(context, pending: pending);
    return false;
  }

  static void navigateToLogin(
    BuildContext context, {
    PendingAuthAction? pending,
  }) {
    _pendingService.setPending(pending);
    Navigator.of(context, rootNavigator: true).pushNamed('/mainLogin');
  }

  static void clearPending() {
    _pendingService.clear();
  }
}
