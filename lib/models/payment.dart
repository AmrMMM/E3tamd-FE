import 'package:e3tmed/models/IModelFactory.dart';
import 'package:injector/injector.dart';
import 'order.dart';

class PaymentRequest implements IJsonSerializable {
  Order order;
  String deviceId;
  String webViewUserAgent;
  String webViewAccept;

  PaymentRequest(
      {required this.order,
      required this.deviceId,
      required this.webViewUserAgent,
      required this.webViewAccept});

  @override
  Map<String, dynamic> toJson() => {
        "order": order.toJson(),
        "deviceId": deviceId,
        "webViewUserAgent": webViewUserAgent,
        "webViewAccept": webViewAccept
      };
}

class PaymentRequestFactory implements IModelFactory<PaymentRequest> {
  @override
  PaymentRequest fromJson(Map<String, dynamic> jsonMap) {
    final orderFactory = Injector.appInstance.get<IModelFactory<Order>>();
    return PaymentRequest(
        order: orderFactory.fromJson(jsonMap["order"]),
        deviceId: jsonMap["deviceId"],
        webViewUserAgent: jsonMap["webViewUserAgent"],
        webViewAccept: jsonMap["webViewAccept"]);
  }
}

class PaymentResult implements IJsonSerializable {
  String paymentUrl;
  String successUrl;
  String failureUrl;
  String transactionCode;

  PaymentResult(
      {required this.paymentUrl,
      required this.successUrl,
      required this.failureUrl,
      required this.transactionCode});

  @override
  Map<String, dynamic> toJson() => {
        "paymentUrl": paymentUrl,
        "successUrl": successUrl,
        "failureUrl": failureUrl,
        "transactionCode": transactionCode
      };
}

class PaymentResultFactory implements IModelFactory<PaymentResult> {
  @override
  PaymentResult fromJson(Map<String, dynamic> jsonMap) {
    return PaymentResult(
        paymentUrl: jsonMap["paymentUrl"],
        successUrl: jsonMap["successUrl"],
        failureUrl: jsonMap["failureUrl"],
        transactionCode: jsonMap["transactionCode"]);
  }
}
