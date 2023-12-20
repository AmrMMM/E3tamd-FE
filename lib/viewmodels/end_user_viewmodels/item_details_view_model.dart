// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:darq/darq.dart';
import 'package:e3tmed/logic/interfaces/IPriceLogic.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/motor.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/price.dart';
import 'package:e3tmed/models/product.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/interfaces/ICart.dart';
import '../../models/agent_requests_model.dart';
import '../../screens/end_user_phase/requesting_item_screen/checkout_screen.dart';
import '../../screens/end_user_phase/requesting_item_screen/item_details_screen/item_details_screen.dart';

class ItemDetailsViewModel
    extends BaseViewModelWithLogicAndArgs<ICoreLogic, ItemDetailsScreenArgs> {
  ItemDetailsViewModel(BuildContext context) : super(context);

  final cart = Injector.appInstance.get<ICart>();
  final strings = Injector.appInstance.get<IStrings>();
  final _totalPrice = BehaviorSubject<PriceDTO?>.seeded(null);
  final ImagePicker _picker = ImagePicker();

  PriceDTO? _lastCalculatedPrice;

  Stream<PriceDTO?> get totalPrice => _totalPrice;

  final _priceLogic = Injector.appInstance.get<IPriceLogic>();

  Future calculatePrice(String? dimension, String? thickness, Motor? motor,
      List<ExtraModel> extras) async {
    _totalPrice.add(null);
    _lastCalculatedPrice = await _priceLogic.calculatePriceForOrder([
      OrderItem(
          product: args!.product,
          motor: motor,
          dimension: dimension,
          thickness: thickness,
          color: "",
          totalPrice: 0,
          priceWithoutExtras: 0,
          isAgent: false,
          additionalNotes: "",
          maintenance: args!.maintenanceMode,
          extras: extras
              .map((e) => OrderItemExtraElement(
                  extraElement: e,
                  purchasePrice: e.price,
                  extraElementId: e.id,
                  quantity: 1))
              .toList(),
          quantity: 1,
          images: [])
    ]);
    _totalPrice.add(_lastCalculatedPrice);
  }

  void navigateToCheckoutForAgent(String notes, List<Uint8List>? imagesList) {
    cart.setCartUsed(false);
    Navigator.of(context).pushNamed("/checkout",
        arguments: CheckoutScreenArgs(orderItems: [
          OrderItem(
              product: args!.product,
              motor: null,
              dimension: null,
              thickness: null,
              color: null,
              totalPrice: 115,
              priceWithoutExtras: 115,
              isAgent: true,
              additionalNotes: notes,
              maintenance: args!.maintenanceMode,
              extras: [],
              quantity: 1,
              images: imagesList
                      ?.map((e) => OrderItemImage(data: base64.encode(e)))
                      .toList() ??
                  []),
        ]));
  }

  void navigateToCheckout(
      String notes,
      String? dimension,
      String? thickness,
      String? color,
      Motor? motor,
      List<ExtraModel> extras,
      int quantity,
      List<Uint8List>? imagesList) async {
    if (_lastCalculatedPrice == null) {
      await calculatePrice(dimension, thickness, motor, extras);
    }
    cart.setCartUsed(false);
    Navigator.of(context).pushNamed("/checkout",
        arguments: CheckoutScreenArgs(orderItems: [
          OrderItem(
              product: args!.product,
              motor: motor,
              dimension: dimension,
              thickness: thickness,
              color: color,
              totalPrice: _lastCalculatedPrice!.totalPrice,
              priceWithoutExtras:
                  _lastCalculatedPrice!.items.sum((e) => e.productPrice),
              isAgent: false,
              additionalNotes: notes,
              maintenance: args!.maintenanceMode,
              extras: extras
                  .map((e) => OrderItemExtraElement(
                      extraElement: e,
                      purchasePrice: e.price,
                      extraElementId: e.id,
                      quantity: 1))
                  .toList(),
              quantity: quantity,
              images: imagesList
                      ?.map((e) => OrderItemImage(data: base64.encode(e)))
                      .toList() ??
                  []),
        ]));
  }

  void addToCart(
      Product product,
      String notes,
      String? dimension,
      String? thickness,
      String? color,
      Motor? motor,
      List<ExtraModel> extras,
      int quantity,
      List<Uint8List>? imagesList) async {
    if (_lastCalculatedPrice == null) {
      await calculatePrice(dimension, thickness, motor, extras);
    }
    var res = await cart.insertItemIntoCartDB(
      OrderItem(
          product: args!.product,
          motor: motor,
          dimension: dimension,
          thickness: thickness,
          color: color,
          totalPrice: args!.product.withExtraDetails
              ? _lastCalculatedPrice!.totalItemsPrice
              : args!.product.basePrice,
          priceWithoutExtras:
              args!.product.withExtraDetails && !args!.maintenanceMode
                  ? _lastCalculatedPrice!.items.sum((e) => e.productPrice)
                  : args!.product.basePrice,
          isAgent: false,
          additionalNotes: notes,
          maintenance: args!.maintenanceMode,
          extras: extras
              .map((e) => OrderItemExtraElement(
                  extraElement: e,
                  purchasePrice: e.price,
                  extraElementId: e.id,
                  quantity: 1))
              .toList(),
          quantity: quantity,
          images: imagesList
                  ?.map((e) => OrderItemImage(data: base64.encode(e)))
                  .toList() ??
              []),
    );
    if (res) {
      Fluttertoast.showToast(
          msg: strings.getStrings(AllStrings.orderAddedToCartTitle),
          gravity: ToastGravity.BOTTOM);
    } else {
      Fluttertoast.showToast(
          msg: strings.getStrings(AllStrings.failedToAddOrderToCartTitle),
          gravity: ToastGravity.BOTTOM);
    }
  }

  Future<Uint8List?> pickImageFromGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    Uint8List? imageData = await image?.readAsBytes();
    if (imageData != null) {
      return imageData;
    } else {
      return null;
    }
  }
}
