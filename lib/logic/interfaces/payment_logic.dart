import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/payment.dart';

abstract class IPaymentLogic {
  Future<PaymentResult?> initiatePayment(
      Order order, String webViewUserAgent, String webViewAccept);
  Future<bool> completePayment(PaymentResult prevResult);
  Future<bool> abortPayment(PaymentResult prevResult);
}
