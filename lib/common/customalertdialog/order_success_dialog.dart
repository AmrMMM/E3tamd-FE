import 'package:e3tmed/DI.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/buttons/secondarybuttonshape.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class OrderSuccessDialog extends StatelessWidget {
  final VoidCallback onViewOrders;
  final VoidCallback onContinueShopping;

  const OrderSuccessDialog({
    Key? key,
    required this.onViewOrders,
    required this.onContinueShopping,
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
                strings.getStrings(AllStrings.orderPlacedSuccessfullyTitle),
                style: TextStyle(
                  color: accentColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                strings
                    .getStrings(AllStrings.orderPlacedSuccessfullyDescription),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              PrimaryButtonShape(
                width: double.infinity,
                text: strings.getStrings(AllStrings.myOrdersTitle),
                color: accentColor,
                stream: null,
                onTap: onViewOrders,
              ),
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

Future<void> showOrderSuccessDialog(BuildContext context) {
  return showDialog(
    barrierDismissible: false,
    useSafeArea: false,
    context: context,
    builder: (dialogContext) => PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        Navigator.of(dialogContext).pop();
        _navigateHome(context);
      },
      child: Dialog(
        child: OrderSuccessDialog(
          onViewOrders: () {
            Navigator.of(dialogContext).pop();
            _navigateHome(context);
            Navigator.of(context).pushNamed("/myOrders");
          },
          onContinueShopping: () {
            Navigator.of(dialogContext).pop();
            _navigateHome(context);
          },
        ),
      ),
    ),
  );
}
