// ignore_for_file: use_build_context_synchronously

import 'package:e3tmed/logic/interfaces/payment_logic.dart';
import 'package:e3tmed/models/payment.dart';
import 'package:e3tmed/screens/end_user_phase/requesting_item_screen/payment_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class PaymentScreenViewModel
    extends BaseViewModelWithLogicAndArgs<IPaymentLogic, PaymentScreenArgs> {
  PaymentScreenViewModel(super.context);

  final _paymentResultStream = BehaviorSubject<PaymentResult?>.seeded(null);
  Stream<PaymentResult?> get paymentResultStream => _paymentResultStream;

  final userAgent = "payment-flutter-eatmed";
  final accept = "text/html";

  @override
  void onArgsPushed() async {
    final res = await logic.initiatePayment(args!.request, userAgent, accept);
    if (res == null) {
      Fluttertoast.showToast(
          msg: "Bank card payment failed, please try again later");
      Navigator.of(context).pop();
      return;
    }
    _paymentResultStream.add(res);
  }

  void onConfirm() async {
    final val = _paymentResultStream.value!;
    _paymentResultStream.add(null);
    final res = await logic.completePayment(val);
    if (res) {
      Fluttertoast.showToast(msg: "Payment completed succesfully!");
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
    } else {
      Fluttertoast.showToast(msg: "Payment failed, please try again");
      Navigator.of(context).pop();
    }
  }

  void onAbort() async {
    final val = _paymentResultStream.value!;
    _paymentResultStream.add(null);
    await logic.abortPayment(val);
    Fluttertoast.showToast(msg: "Payment Aborted!");
    Navigator.of(context).pop();
  }
}
