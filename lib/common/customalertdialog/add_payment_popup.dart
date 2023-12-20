import 'package:e3tmed/DI.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

class AddPaymentPopUpDialog extends StatefulWidget {
  final void Function(bool) paymentCallback;
  final Order order;

  const AddPaymentPopUpDialog(
      {Key? key, required this.paymentCallback, required this.order})
      : super(key: key);

  @override
  State<AddPaymentPopUpDialog> createState() => _AddPaymentPopUpDialogState();
}

class _AddPaymentPopUpDialogState extends State<AddPaymentPopUpDialog> {
  final strings = Injector.appInstance.get<IStrings>();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: useLanguage == Languages.arabic.name
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: Wrap(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const SizedBox(width: 10),
                Text(
                  strings.getStrings(AllStrings.addCardTitle),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
              ]),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const Divider(
            thickness: 0.7,
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Column(
                children: [
                  PrimaryButtonShape(
                      width: double.infinity,
                      text: strings
                          .getStrings(AllStrings.paymentMethodCashTitle),
                      color: Theme.of(context).colorScheme.secondary,
                      stream: null,
                      onTap: () {
                        widget.paymentCallback(false);
                        Navigator.of(context).pop();
                      }),
                  const Divider(
                    thickness: 0.7,
                  ),
                  PrimaryButtonShape(
                      width: double.infinity,
                      text: strings
                          .getStrings(AllStrings.paymentMethodCardTitle),
                      color: Theme.of(context).colorScheme.secondary,
                      stream: null,
                      onTap: () {
                        widget.paymentCallback(true);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
