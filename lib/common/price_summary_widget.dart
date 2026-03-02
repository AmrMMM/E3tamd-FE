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

class PriceSummaryWidget extends StatefulWidget {
  const PriceSummaryWidget({Key? key, this.orderItems, this.orderId})
      : super(key: key);
  final List<OrderItem>? orderItems;
  final int? orderId;

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
                          value: totalProductPrice.toString())),
                if (totalSparePartsPrice != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: _DetailsItem(
                          item: strings.getStrings(AllStrings.sparePartsTitle),
                          value: totalSparePartsPrice.toString())),
                if (totalExtrasPrice != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: _DetailsItem(
                          item: strings
                              .getStrings(AllStrings.extrasAndServicesTitle),
                          value: totalExtrasPrice.toString())),
                if (totalAgentVisitPrice != 0)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1),
                      child: _DetailsItem(
                          item: strings.getStrings(AllStrings.agentVisitTitle),
                          value: totalAgentVisitPrice.toString())),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: _DetailsItem(
                        item: strings.getStrings(AllStrings.vatTitle),
                        value: totalVatPrice.toString())),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _DetailsItem(
                      isTotal: true,
                      item: strings.getStrings(AllStrings.totalTitle),
                      value: "${finalTotalPrice.toString()} SAR",
                    )),
                if (paidAmount > 0) ...[
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _DetailsItem(
                        item: strings.getStrings(AllStrings.paidAmount),
                        value: "${paidAmount.toString()} SAR",
                      )),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: _DetailsItem(
                        isTotal: true,
                        item: strings.getStrings(AllStrings.totalDue),
                        value:
                            "${(finalTotalPrice - paidAmount).toString()} SAR",
                      )),
                ]
              ],
            ))
        : const Center(child: MainLoadinIndicatorWidget());
  }
}

// ignore: must_be_immutable
class _DetailsItem extends StatelessWidget {
  final String item;
  final String value;
  bool? mainTitle;
  bool? isTotal;

  _DetailsItem(
      {Key? key,
      required this.item,
      required this.value,
      this.mainTitle,
      this.isTotal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(item,
            style: mainTitle ?? false
                ? const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)
                : isTotal ?? false
                    ? const TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)
                    : const TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 14)),
        Text(
          value,
          style: mainTitle ?? false
              ? const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)
              : isTotal ?? false
                  ? const TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                      fontSize: 14)
                  : const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                      fontSize: 14),
        )
      ],
    );
  }
}
