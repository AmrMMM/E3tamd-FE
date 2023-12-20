import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import '../../screens/end_user_phase/settings/addresses_screen.dart';

class AddressesViewModel
    extends BaseViewModelWithLogicAndArgs<IAuth, UserAddressesScreenArguments> {
  AddressesViewModel(BuildContext context) : super(context) {
    _init();
  }

  final _userAddresses = BehaviorSubject<List<UserAddress>?>.seeded(null);
  final _addressState = BehaviorSubject<bool?>.seeded(null);

  Stream<List<UserAddress>?> get userAddresses => _userAddresses;

  Stream<bool?> get addressState => _addressState;

  void _init() async {
    _userAddresses.add(null);
    _userAddresses.add(await logic.getUserAddresses());
  }

  void saveAddressChanges(UserAddress newAddress) async {
    _addressState.add(true);
    bool res = false;
    if (newAddress.id != 0) {
      res = await logic.updateAddress(newAddress);
    } else {
      res = await logic.insertNewAddress(newAddress);
    }
    if (res) {
      _addressState.add(false);
    }
    _addressState.add(null);
    _init();
  }

  void deleteAddress(UserAddress address) async {
    _addressState.add(true);
    final res = await logic.deleteAddress(address);
    if (res) {
      _addressState.add(false);
    }
    _addressState.add(null);
    _init();
  }

  void makePrimary(UserAddress address) async {
    _addressState.add(true);
    address.isPrimary = true;
    final res = await logic.updateAddress(address);
    if (res) {
      _addressState.add(false);
    }
    _addressState.add(null);
    _init();
  }

  void selectAddress(UserAddress address) {
    Navigator.of(context).pop();
    args!.selectedCallback(address);
  }
}
