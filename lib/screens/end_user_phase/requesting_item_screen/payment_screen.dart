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
        // Set navigation delegate before loading the URL
        controller.setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              if (request.url == event.successUrl) {
                viewModel.onConfirm();
                return NavigationDecision.prevent;
              } else if (request.url == event.failureUrl) {
                viewModel.onAbort();
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onWebResourceError: (error) {
              // Handle WebView errors
              debugPrint('WebView Error: ${error.description}');
              debugPrint('Error Code: ${error.errorCode}');
              debugPrint('Error Type: ${error.errorType}');
              debugPrint('Failed URL: ${error.url}');

              // Show user-friendly error message
              if (error.errorCode == -2 ||
                  error.description.contains('ERR_NAME_NOT_RESOLVED') == true ||
                  error.description.contains('net::ERR_NAME_NOT_RESOLVED') ==
                      true) {
                // Network/DNS error
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Network error: Unable to connect to payment server. Please check your internet connection.'),
                    duration: Duration(seconds: 5),
                  ),
                );
              }
            },
            onPageStarted: (url) {
              debugPrint('Page started loading: $url');
            },
            onPageFinished: (url) {
              debugPrint('Page finished loading: $url');
            },
          ),
        );

        // Load the payment URL with proper headers
        try {
          final uri = Uri.parse(event.paymentUrl);
          debugPrint('Loading payment URL: ${uri.toString()}');
          controller.loadRequest(
            uri,
            headers: {"Accept": viewModel.accept},
          );
        } catch (e) {
          debugPrint('Error parsing payment URL: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Invalid payment URL: $e'),
              duration: const Duration(seconds: 5),
            ),
          );
        }
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
