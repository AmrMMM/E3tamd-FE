import 'package:e3tmed/models/pending_auth_action.dart';
import 'package:flutter/material.dart';

abstract class IPendingAuthAction {
  PendingAuthAction? get pending;

  void setPending(PendingAuthAction? action);

  void clear();

  Future<void> executePending(BuildContext context);
}
