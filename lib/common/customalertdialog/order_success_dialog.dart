import 'package:e3tmed/DI.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/buttons/secondarybuttonshape.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class OrderSuccessDialog extends StatelessWidget {
  final VoidCallback onViewOrders;
  final VoidCallback onContinueShopping;

  /// A difference/top-up payment (not a brand-new order). Shows a single
  /// confirm button and a "payment successful" message instead of the
  /// order-placed shopping actions.
  final bool isDifferencePayment;

  const OrderSuccessDialog({
    Key? key,
    required this.onViewOrders,
    required this.onContinueShopping,
    this.isDifferencePayment = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final strings = Injector.appInstance.get<IStrings>();
    final accentColor = Theme.of(context).colorScheme.secondary;

    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_outline,
                color: accentColor,
                size: 56,
              ),
              const SizedBox(height: 12),
              Text(
                strings.getStrings(isDifferencePayment
                    ? AllStrings.paymentSuccessfulTitle
                    : AllStrings.orderPlacedSuccessfullyTitle),
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (!isDifferencePayment) ...[
                const SizedBox(height: 8),
                Text(
                  strings.getStrings(
                      AllStrings.orderPlacedSuccessfullyDescription),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 8),
              PrimaryButtonShape(
                width: double.infinity,
                text: strings.getStrings(isDifferencePayment
                    ? AllStrings.confirmTitle
                    : AllStrings.myOrdersTitle),
                color: accentColor,
                stream: null,
                onTap: onViewOrders,
              ),
              if (!isDifferencePayment)
                SecondaryButtonShape(
                  width: double.infinity,
                  text: strings.getStrings(AllStrings.continueShoppingTitle),
                  color: accentColor,
                  stream: null,
                  clickable: true,
                  onTap: onContinueShopping,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

void _navigateHome(BuildContext context) {
  Navigator.of(context).pushNamedAndRemoveUntil("/home", (_) => false);
}

Future<void> showOrderSuccessDialog(BuildContext context,
    {bool isDifferencePayment = false}) {
  return showDialog(
    barrierDismissible: false,
    useSafeArea: false,
    context: context,
    builder: (dialogContext) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(dialogContext).pop();
        // A difference payment must NOT navigate home — the caller pops the
        // payment screen afterwards to return to the order. Navigating home
        // here would destroy that screen and crash the subsequent pop.
        if (!isDifferencePayment) _navigateHome(context);
      },
      child: Dialog(
        child: OrderSuccessDialog(
          isDifferencePayment: isDifferencePayment,
          onViewOrders: () {
            Navigator.of(dialogContext).pop();
            if (!isDifferencePayment) {
              _navigateHome(context);
              Navigator.of(context).pushNamed("/myOrders");
            }
          },
          onContinueShopping: () {
            Navigator.of(dialogContext).pop();
            if (!isDifferencePayment) _navigateHome(context);
          },
        ),
      ),
    ),
  );
}
