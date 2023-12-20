import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:e3tmed/logic/interfaces/IHTTP.dart';
import 'package:e3tmed/logic/interfaces/payment_logic.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/payment.dart';
import 'package:injector/injector.dart';

class PaymentLogic implements IPaymentLogic {
  final http = Injector.appInstance.get<IHTTP>();

  Future<String?> _getId() async {
    if (Platform.isIOS) {
      var deviceInfo = DeviceInfoPlugin();
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      return await const AndroidId().getId();
    } else {
      return null;
    }
  }

  @override
  Future<bool> abortPayment(PaymentResult prevResult) async {
    final res = await http
        .post("Payment/Abort", queryArgs: {"code": prevResult.transactionCode});
    return res.statusCode == 200;
  }

  @override
  Future<bool> completePayment(PaymentResult prevResult) async {
    final res = await http.post("Payment/Confirm",
        queryArgs: {"code": prevResult.transactionCode});
    return res.statusCode == 200;
  }

  @override
  Future<PaymentResult?> initiatePayment(
      Order order, String webViewUserAgent, String webViewAccept) async {
    final res = await http.rpost<PaymentResult>("Payment",
        body: PaymentRequest(
            order: order,
            deviceId: await _getId() ?? "0",
            webViewUserAgent: webViewUserAgent,
            webViewAccept: webViewAccept));
    if (res.statusCode == 200 && res.body != null) {
      return res.body![0];
    }
    return null;
  }
}
