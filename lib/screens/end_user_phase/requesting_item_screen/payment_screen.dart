import 'dart:convert';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/main_loading.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/payment.dart';
import 'package:e3tmed/viewmodels/end_user_viewmodels/payment_screen_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreenArgs {
  Order request;
  PaymentScreenArgs({required this.request});
}

class PaymentScreen extends ScreenWidget {
  PaymentScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => PaymentScreenState(context);
}

class PaymentScreenState extends BaseStateArgumentObject<PaymentScreen,
    PaymentScreenViewModel, PaymentScreenArgs> {
  PaymentScreenState(context) : super(() => PaymentScreenViewModel(context));

  late WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent(viewModel.userAgent);

    viewModel.paymentResultStream.listen((event) {
      if (event != null) {
        controller.loadRequest(Uri.parse(event.paymentUrl),
            headers: {"Accept": viewModel.accept});
        controller.setNavigationDelegate(
            NavigationDelegate(onNavigationRequest: (request) {
          if (request.url == event.successUrl) {
            viewModel.onConfirm();
            return NavigationDecision.prevent;
          } else if (request.url == event.failureUrl) {
            viewModel.onAbort();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        }));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
              child: StreamBuilder<PaymentResult?>(
                stream: viewModel.paymentResultStream,
                initialData: null,
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: MainLoadinIndicatorWidget());
                  }
                  return WebViewWidget(controller: controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
