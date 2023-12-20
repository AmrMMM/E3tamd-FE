// ignore_for_file: no_logic_in_create_state

import 'dart:async';

import 'package:e3tmed/DI.dart';
import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../common/custom_cart_item/custom_cart_item.dart';
import '../../../viewmodels/end_user_viewmodels/cart_view_model.dart';

class CartScreen extends ScreenWidget {
  CartScreen(BuildContext context) : super(context);

  @override
  CartScreenState createState() => CartScreenState(context);
}

class CartScreenState extends BaseStateObject<CartScreen, CartViewModel> {
  CartScreenState(BuildContext context) : super(() => CartViewModel(context));
  double subtotal = 0;
  List<OrderItem>? cartList = [];
  late StreamSubscription _cartListSub;
  late StreamSubscription _authSub;
  late StreamSubscription _addressSub;
  final strings = Injector.appInstance.get<IStrings>();
  UserAuthModel? _auth;
  String _address = "";

  @override
  void initState() {
    super.initState();
    _cartListSub = viewModel.cartList.listen((event) {
      setState(() {
        cartList = event;
        if (event?.isEmpty ?? true) {
          subtotal = 0;
        } else {
          subtotal = event!
              .map((e) => (e.totalPrice! * e.quantity.toDouble()))
              .reduce((value, element) => (value + element));
        }
      });
    });

    _authSub = viewModel.authModel.listen((event) {
      if (event == null) {
        return;
      }
      setState(() {
        _auth = event;
      });
    });

    _addressSub = viewModel.selectedUserAddress.listen((event) {
      if (event != null) {
        setState(() {
          _address = event.address;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _cartListSub.cancel();
    _authSub.cancel();
    _addressSub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings.getStrings(AllStrings.cartTitle),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Directionality(
        textDirection: useLanguage == Languages.arabic.name?TextDirection.rtl:TextDirection.ltr,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: const Color.fromRGBO(19, 98, 110, 1),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_auth?.address != null)
                    TextButton.icon(
                        onPressed: null,
                        icon: const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text(
                          "${strings.getStrings(AllStrings.deliverToTitle)} $_address",
                          style:
                              const TextStyle(color: Colors.white, fontSize: 12),
                        )),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    strings.getStrings(AllStrings.subtotalTitle),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: "$subtotal",
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                      const TextSpan(
                          text: "  SAR", style: TextStyle(color: Colors.black)),
                    ]),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: cartList?.isNotEmpty ?? false
                  ? ListView(
                      children: cartList!
                          .map((event) => Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: CustomCartItemWidget(
                                  orderItem: event,
                                  deleteItemFromDB: (event) =>
                                      viewModel.deleteItemFromDB(event),
                                  onTap: (event) =>
                                      viewModel.navigateToCheckoutScreen(event),
                                  callBack: (quantity) {
                                    setState(() {
                                      event.quantity = quantity;
                                      subtotal = cartList!
                                          .map((e) => (e.totalPrice! *
                                              e.quantity.toDouble()))
                                          .reduce((value, element) =>
                                              (value + element));
                                    });
                                  },
                                ),
                              ))
                          .toList(),
                    )
                  : Center(
                      child: Text(
                        strings.getStrings(AllStrings.yourListIsEmptyTitle),
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                    ),
            ),
            cartList?.isNotEmpty ?? false
                ? Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: PrimaryButtonShape(
                        width: double.infinity,
                        text:
                            "${strings.getStrings(AllStrings.proceedToBuyTitle)} ${cartList?.length ?? 0} ${strings.getStrings(AllStrings.itemsTitle)}",
                        color: Theme.of(context).colorScheme.secondary,
                        clickable: cartList?.isEmpty ?? true,
                        stream: null,
                        onTap: () =>
                            viewModel.proceedToCheckoutAllItem(cartList ?? [])),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
