import 'package:darq/darq.dart';
import 'package:e3tmed/logic/interfaces/IPriceLogic.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../DI.dart';
import '../logic/interfaces/IStrings.dart';
import '../models/order.dart';
import '../models/price.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';
import 'main_loading.dart';
import 'price_text.dart';

class PriceSummaryWidget extends StatefulWidget {
  const PriceSummaryWidget(
      {Key? key, this.orderItems, this.orderId, this.onPayDifference})
      : super(key: key);
  final List<OrderItem>? orderItems;
  final int? orderId;

  // When provided and there is an outstanding balance, a "Pay remaining" button
  // is shown that invokes this callback with the amount still due.
  final void Function(double amountDue)? onPayDifference;

  @override
  State<PriceSummaryWidget> createState() => _PriceSummaryWidgetState();
}

class _PriceSummaryWidgetState extends State<PriceSummaryWidget> {
  final strings = Injector.appInstance.get<IStrings>();
  final priceCalcLogic = Injector.appInstance.get<IPriceLogic>();
  PriceDTO? priceDtoObj;
  double totalProductPrice = 0,
      totalExtrasPrice = 0,
      totalSparePartsPrice = 0,
      totalAgentVisitPrice = 0,
      totalVatPrice = 0,
      finalTotalPrice = 0,
      paidAmount = 0;

  initAsyncFunction() async {
    if (widget.orderId != null) {
      priceDtoObj = await priceCalcLogic.calculatePriceForId(widget.orderId!);
    }
    if (widget.orderItems != null) {
      var paidAmount = 0.0;
      if (priceDtoObj != null) {
        paidAmount = priceDtoObj!.paidAmount;
      }
      priceDtoObj =
          await priceCalcLogic.calculatePriceForOrder(widget.orderItems!);
      priceDtoObj?.paidAmount = paidAmount;
    }
    priceDtoObj?.items.sum((e) => e.extrasAndServices);
    if (priceDtoObj != null) {
      if (mounted) {
        setState(() {
          totalProductPrice = priceDtoObj!.items.sum((e) => e.productPrice);
          totalExtrasPrice = priceDtoObj!.items.sum((e) => e.extrasAndServices);
          totalAgentVisitPrice = priceDtoObj!.agentVisit;
          totalVatPrice = priceDtoObj!.vat;
          finalTotalPrice = priceDtoObj!.totalPrice;
          paidAmount = priceDtoObj!.paidAmount;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    initAsyncFunction();
    // totalProductPrice = widget.orderItems
    //     .map((e) => !e.maintenance && !e.isAgent ? e.totalPrice ?? 0 : 0.0)
    //     .reduce((value, element) => value + element);
    // final spareList =
    //     widget.orderItems.expand((element) => element.extraProducts ?? []);
    // if (spareList.isNotEmpty) {
    //   totalSparePartsPrice = spareList
    //       .map((e) => e.purchasePrice!)
    //       .reduce((value, element) => value + element);
    // }
    // final extrasList = widget.orderItems.expand((element) => element.extras);
    // if (extrasList.isNotEmpty) {
    //   totalExtrasPrice = extrasList
    //       .map((e) => e.purchasePrice!)
    //       .reduce((value, element) => value + element);
    // }
    // totalAgentVisitPrice = VAT.toDouble();
    // totalVatPrice = VAT.toDouble();
    // finalTotalPrice = (totalProductPrice +
    //     totalSparePartsPrice +
    //     totalExtrasPrice +
    //     totalAgentVisitPrice +
    //     totalVatPrice);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return priceDtoObj != null
        ? Directionality(
            textDirection: useLanguage == Languages.arabic.name
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: _DetailsItem(
                        mainTitle: true,
                        item: strings.getStrings(AllStrings.priceDetailsTitle),
                        value: "")),
                if (totalProductPrice != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: _DetailsItem(
                          item:
                              strings.getStrings(AllStrings.productPriceTitle),
                          amount: totalProductPrice)),
                if (totalSparePartsPrice != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: _DetailsItem(
                          item: strings.getStrings(AllStrings.sparePartsTitle),
                          amount: totalSparePartsPrice)),
                if (totalExtrasPrice != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: _DetailsItem(
                          item: strings
                              .getStrings(AllStrings.extrasAndServicesTitle),
                          amount: totalExtrasPrice)),
                if (totalAgentVisitPrice != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: _DetailsItem(
                          item: strings.getStrings(AllStrings.agentVisitTitle),
                          amount: totalAgentVisitPrice)),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: _DetailsItem(
                        item: strings.getStrings(AllStrings.vatTitle),
                        amount: totalVatPrice)),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _DetailsItem(
                      isTotal: true,
                      item: strings.getStrings(AllStrings.totalTitle),
                      amount: finalTotalPrice,
                    )),
                if (paidAmount > 0) ...[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _DetailsItem(
                        item: strings.getStrings(AllStrings.paidAmount),
                        amount: paidAmount,
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _DetailsItem(
                        isTotal: true,
                        item: strings.getStrings(AllStrings.totalDue),
                        // Never render a negative balance: an overpaid order owes
                        // nothing, it does not owe a negative amount.
                        amount: (finalTotalPrice - paidAmount)
                            .clamp(0, double.infinity),
                      )),
                  if (widget.onPayDifference != null &&
                      (finalTotalPrice - paidAmount) > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => widget
                              .onPayDifference!(finalTotalPrice - paidAmount),
                          icon: const Icon(Icons.credit_card),
                          label: Text.rich(TextSpan(children: [
                            TextSpan(
                                text:
                                    "${strings.getStrings(AllStrings.payRemainingTitle)} ("),
                            priceSpan(finalTotalPrice - paidAmount),
                            const TextSpan(text: ")"),
                          ])),
                        ),
                      ),
                    ),
                ]
              ],
            ))
        : const Center(child: MainLoadinIndicatorWidget());
  }
}

// ignore: must_be_immutable
class _DetailsItem extends StatelessWidget {
  final String item;
  // A plain-text value (e.g. the section header's empty string). Monetary rows
  // pass [amount] instead so the value renders through PriceText with the symbol.
  final String value;
  final double? amount;
  bool? mainTitle;
  bool? isTotal;

  _DetailsItem(
      {Key? key,
      required this.item,
      this.value = "",
      this.amount,
      this.mainTitle,
      this.isTotal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = mainTitle ?? false
        ? const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)
        : isTotal ?? false
            ? const TextStyle(
                color: Colors.teal, fontWeight: FontWeight.bold, fontSize: 14)
            : const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.normal,
                fontSize: 14);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item, style: textStyle),
        amount != null
            ? PriceText(amount!, style: textStyle)
            : Text(value, style: textStyle),
      ],
    );
  }
}
