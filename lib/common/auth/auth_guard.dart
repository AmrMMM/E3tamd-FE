import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IPendingAuthAction.dart';
import 'package:e3tmed/models/pending_auth_action.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AuthGuard {
  static final _auth = Injector.appInstance.get<IAuth>();
  static final _pendingService = Injector.appInstance.get<IPendingAuthAction>();

  static bool get isClientLoggedIn => _auth.isClient;

  /// Sends a guest to login and reports `false` immediately; the caller's work is resumed afterwards
  /// by [IPendingAuthAction.executePending]. Use this when the action can be described as a
  /// [PendingAuthAction].
  static Future<bool> requireClientLogin(
    BuildContext context, {
    PendingAuthAction? pending,
  }) async {
    if (_auth.isClient) return true;
    navigateToLogin(context, pending: pending);
    return false;
  }

  /// Awaits the whole login flow and reports whether the user ended up authenticated, so the caller
  /// can simply carry on inline afterwards.
  ///
  /// Deliberately registers no [PendingAuthAction]: callers of this method resume their own work, so
  /// also queueing a pending action would run that work twice. Each call site picks one mechanism -
  /// awaited-and-inline (here) or fire-and-forget-with-pending ([requireClientLogin]).
  static Future<bool> ensureClientLogin(BuildContext context) async {
    if (_auth.isClient) return true;

    // The login route is pushed on the root navigator, above /home, so the screen the caller lives
    // on survives underneath and still holds its state when this returns.
    await Navigator.of(context, rootNavigator: true).pushNamed('/mainLogin');
    return _auth.isClient;
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
