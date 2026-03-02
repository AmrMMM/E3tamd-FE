import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/ICart.dart';
import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/payment.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:e3tmed/screens/end_user_phase/requesting_item_screen/payment_screen.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/interfaces/IStrings.dart';
import '../../screens/end_user_phase/requesting_item_screen/checkout_screen.dart';
import '../../screens/end_user_phase/settings/addresses_screen.dart';

class CheckoutViewModel
    extends BaseViewModelWithLogicAndArgs<ICoreLogic, CheckoutScreenArgs> {
  CheckoutViewModel(BuildContext context) : super(context) {
    _init();
  }

  final authLogic = Injector.appInstance.get<IAuth>();
  final _selectedUserAddress = BehaviorSubject<UserAddress?>.seeded(null);
  final strings = Injector.appInstance.get<IStrings>();
  final _makeOrderState = BehaviorSubject<bool?>.seeded(null);
  final _addressState = BehaviorSubject<bool?>.seeded(null);
  final cartLogic = Injector.appInstance.get<ICart>();
  var isBankCardPayment = false;

  final Order order = Order(
      addedDate: DateTime.now(),
      address: UserAddress(
          address: "",
          city: "",
          country: "",
          id: 0,
          isPrimary: true,
          region: ""),
      items: [],
      phoneNumber: "",
      totalPrice: 0.0);

  Stream<UserAuthModel?> get auth => authLogic.authData;

  Stream<UserAddress?> get selectedUserAddress => _selectedUserAddress;

  Stream<bool?> get makeOrderState => _makeOrderState;

  Stream<bool?> get addressState => _addressState;

  void _init() async {
    final addresses = (await authLogic.getUserAddresses());
    if (addresses.isNotEmpty) {
      order.address = (await authLogic.getUserAddresses())
          .firstWhere((element) => element.isPrimary);
      _selectedUserAddress.add(order.address);
    }
  }

  @override
  void onArgsPushed() {
    order.items = args!.orderItems;
  }

  void saveAddressChanges(UserAddress newAddress) async {
    _addressState.add(true);
    bool res = false;
    if (newAddress.id != 0) {
      res = await authLogic.updateAddress(newAddress);
    } else {
      res = await authLogic.insertNewAddress(newAddress);
    }
    if (res) {
      _addressState.add(false);
    }
    _addressState.add(null);
    _init();
  }

  void setPaymentMode(bool isCardPayment) {
    isBankCardPayment = isCardPayment;
  }

  void makeOrder() async {
    if (isBankCardPayment) {
      Navigator.of(context)
          .pushNamed("/payment", arguments: PaymentScreenArgs(request: order));
      return;
    }
    _makeOrderState.add(null);
    _addressState.add(true);
    final res = await logic.makeOrder(order);
    if (res) {
      // ignore: use_build_context_synchronously
      cartLogic.checkoutCallback();
      Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
      Fluttertoast.showToast(
          msg: strings.getStrings(AllStrings.thanksForOrderingTitle),
          gravity: ToastGravity.BOTTOM);
    }
    _addressState.add(false);
    _makeOrderState.add(res);
  }

  void onUpdateAddressCard() {
    _init();
  }

  void deleteAddress(UserAddress address) async {
    _addressState.add(true);
    final res = await authLogic.deleteAddress(address);
    if (res) {
      _addressState.add(false);
    }
    _addressState.add(null);
    _init();
  }

  void navigateToAddressScreen() {
    Navigator.of(context).pushNamed("/addresses",
        arguments: UserAddressesScreenArguments(selectedCallback: (address) {
      order.address = address;
      _selectedUserAddress.add(order.address);
    }));
  }
}
