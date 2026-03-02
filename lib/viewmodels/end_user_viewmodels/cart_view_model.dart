// ignore_for_file: use_build_context_synchronously

import 'package:e3tmed/DI.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/screens/end_user_phase/requesting_item_screen/item_details_screen/item_details_screen.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/interfaces/ICart.dart';
import '../../models/user_address.dart';
import '../../screens/end_user_phase/requesting_item_screen/checkout_screen.dart';

class CartViewModel extends BaseViewModelWithLogic<ICart> {
  CartViewModel(BuildContext context) : super(context) {
    _init();
  }

  late UserAddress _selectedAddress;

  Stream<List<OrderItem>?> get cartList => logic.carList;
  final IAuth auth = Injector.appInstance.get<IAuth>();
  final _selectedUserAddress = BehaviorSubject<UserAddress?>.seeded(null);
  final strings = Injector.appInstance.get<IStrings>();

  Stream<UserAuthModel?> get authModel => auth.authData;

  Stream<UserAddress?> get selectedUserAddress => _selectedUserAddress;

  void _init() async {
    final addresses = (await auth.getUserAddresses());
    if (addresses.isNotEmpty) {
      _selectedAddress = (await auth.getUserAddresses())
          .firstWhere((element) => element.isPrimary);
      _selectedUserAddress.add(_selectedAddress);
    }
  }

  deleteItemFromDB(OrderItem product) async {
    var res = await logic.deleteItemFromCartDB(product);
    if (res) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          strings.getStrings(AllStrings.orderRemovedFromCartTitle),
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          textDirection: useLanguage == Languages.arabic.name?TextDirection.rtl:TextDirection.ltr,
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        strings.getStrings(AllStrings.failedToRemoveOrderFromCartTitle),
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textDirection: useLanguage == Languages.arabic.name?TextDirection.rtl:TextDirection.ltr,
      )));
    }
  }

  navigateToCheckoutScreen(OrderItem orderItem) {
    Navigator.of(context).pushNamed("/itemDetails",
        arguments: ItemDetailsScreenArgs(
            product: orderItem.product,
            maintenanceMode: orderItem.maintenance));
  }

  proceedToCheckoutAllItem(List<OrderItem> cartList) {
    logic.setCartUsed(true);
    Navigator.of(context).pushNamed("/checkout",
        arguments: CheckoutScreenArgs(orderItems: cartList));
  }
}
