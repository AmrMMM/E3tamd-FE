import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/payment.dart';

abstract class IPaymentLogic {
  Future<PaymentResult?> initiatePayment(
      Order order, String webViewUserAgent, String webViewAccept);
  // Starts a card payment for the outstanding balance on an already-placed order.
  Future<PaymentResult?> payDifference(int orderId);
  Future<bool> completePayment(String paymentId);
  Future<bool> abortPayment(PaymentResult prevResult);
}
