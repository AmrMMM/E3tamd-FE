import 'dart:core';

import 'package:e3tmed/DI.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/ISocial.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/agent_requests_model.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/screens/agent_phase/order/agent_order_details_screen.dart';
import 'package:e3tmed/screens/agent_phase/order/agent_order_summary_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../../models/category.dart';
import '../../../models/product.dart';

class AgentOrderDetailsViewModel
    extends BaseViewModelWithLogicAndArgs<IAuth, AgentOrderDetailsScreenArgs> {
  AgentOrderDetailsViewModel(BuildContext context) : super(context);

  final _social = Injector.appInstance.get<ISocial>();
  final _coreLogic = Injector.appInstance.get<ICoreLogic>();
  final _itemsList = BehaviorSubject<List<Product>?>.seeded(null);
  final _loading = BehaviorSubject<bool>();
  final BehaviorSubject<double> _totalPriceDetails = BehaviorSubject.seeded(0);

  Stream<double> get totalPriceDetails => _totalPriceDetails;

  Stream<List<Product>?> get itemsList => _itemsList;

  Stream<bool> get loading => _loading;

  final double vat = VAT;

  @override
  void onArgsPushed() {
    getSparePartsList(Category(
        id: 6,
        nameAr: "قطع غيار",
        nameEn: "Spare parts",
        maintenanceCategoryId: null));
    // calculateTotalPriceDetails();
  }

  // calculateTotalPriceDetails() async {
  //   double currentMoney = args!.request.items
  //       .map((e) => e.totalPrice ?? 0)
  //       .reduce((value, element) => value + element);
  //   double sparePrice = 0;
  //   final allSparePartsPrice =
  //       args!.request.items.expand((e) => e.extraProducts!);
  //   if (allSparePartsPrice.isNotEmpty) {
  //     sparePrice = allSparePartsPrice
  //         .map((e) => e.purchasePrice!)
  //         .reduce((value, element) => value + element);
  //   }
  //   double extraPrice = 0;
  //   final allExtrasPrice = args!.request.items.expand((e) => e.extras);
  //   if (allExtrasPrice.isNotEmpty) {
  //     extraPrice = allExtrasPrice
  //         .map((e) => e.extraElement!.price)
  //         .reduce((value, element) => value + element);
  //   }
  //   _totalPriceDetails.add(currentMoney + extraPrice + sparePrice + vat);
  // }

  void getSparePartsList(Category category) async {
    _itemsList.add(await _coreLogic.getProductsOf(category));
  }

  addExtraToTotal(List<ExtraModel> extraItem, OrderItem requestItem) {
    requestItem.extras.addAll(extraItem
        .map((e) => OrderItemExtraElement(
            extraElement: e,
            purchasePrice: e.price,
            extraElementId: e.id,
            quantity: 1))
        .toList());
    // calculateTotalPriceDetails();
  }

  removeExtraFromTotal(ExtraModel extraItem, OrderItem requestItem) {
    requestItem.extras.remove(requestItem.extras
        .firstWhere((element) => element.extraElement == extraItem));
  }

  addSpareToTotal(
      List<OrderItemExtraProduct> productItem, OrderItem requestItem) {
    requestItem.extraProducts?.addAll(productItem);
    // calculateTotalPriceDetails();
  }

  removeSpareFromTotal(Product productItem, OrderItem requestItem) {
    requestItem.extraProducts?.remove(requestItem.extraProducts
        ?.firstWhere((element) => element.product == productItem));
  }

  updateItemDetails(
    OrderItem requestItem,
    String? dimension,
    String? thickness,
    String? color,
    Motor? motor,
    String? notes,
  ) {
    requestItem.dimension = dimension ?? requestItem.dimension;
    requestItem.thickness = thickness ?? requestItem.thickness;
    requestItem.color = color ?? requestItem.color;
    requestItem.motor = motor;
    requestItem.motor = motor;
    requestItem.additionalNotes = notes ?? requestItem.additionalNotes;
    if (requestItem.dimension != null &&
        requestItem.thickness != null &&
        requestItem.color != null &&
        motor != null) {
      requestItem.product.withExtraDetails = true;
      requestItem.maintenance = false;
      requestItem.isAgent = false;
    }
  }

  saveAndContinue() {
    Navigator.of(context).pushNamed(
      "/aOrderSummaryScreen",
      arguments: AgentOrderSummaryScreenArgs(
          totalPrice: _totalPriceDetails.value,
          request: args!.request,
          onComplete: () {
            Navigator.of(context).pop();
            args!.callback();
          }),
    );
  }

  callThisNumber(String phoneNumber) async {
    await _social.contactWithPhoneNumber(phoneNumber);
  }
}
