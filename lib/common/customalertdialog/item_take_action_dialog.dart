import 'package:e3tmed/common/custom_dotted_border/custom_dotted_border.dart';
import 'package:e3tmed/common/price_summary_widget.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import '../../DI.dart';
import '../../models/order.dart';
import '../buttons/primarybuttonshape.dart';
import '../buttons/secondarybuttonshape.dart';

class ItemTakeActionDialog extends StatelessWidget {
  final void Function() onCheckout;
  final void Function() addToCart;
  final List<OrderItem> items;
  final strings = Injector.appInstance.get<IStrings>();

  ItemTakeActionDialog(
      {Key? key,
      required this.items,
      required this.onCheckout,
      required this.addToCart})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      strings.getStrings(AllStrings.saveAndContinueTitle),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16),
                    ),
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ],
                ),
                const Divider(
                  thickness: 1,
                ),
                CustomDottedBorderWidget(
                  message: strings.getStrings(AllStrings
                      .priceMayChangeAccordingToAgentsVisitAndFeesWillBeDeductedFromTotalPaymentWhenTheRequestIsCompletedTitle),
                ),
                PriceSummaryWidget(orderItems: items),
                Container(
                  height: 10,
                ),
                SecondaryButtonShape(
                  width: double.infinity,
                  text: strings.getStrings(AllStrings.continueCheckoutTitle),
                  color: Theme.of(context).colorScheme.secondary,
                  stream: null,
                  clickable: true,
                  onTap: onCheckout,
                ),
                PrimaryButtonShape(
                  width: double.infinity,
                  text: strings.getStrings(AllStrings.addToCartTitle),
                  color: Theme.of(context).colorScheme.secondary,
                  stream: null,
                  onTap: addToCart,
                )
              ],
            )),
      ),
    );
  }
}
