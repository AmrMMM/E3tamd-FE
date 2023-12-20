import 'package:dotted_border/dotted_border.dart';
import 'package:e3tmed/DI.dart';
import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/address_card/address_card.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../common/customalertdialog/customeaddressedialog.dart';
import '../../../common/main_loading.dart';
import '../../../viewmodels/end_user_viewmodels/addresses_view_model.dart';

class UserAddressesScreenArguments {
  void Function(UserAddress selected) selectedCallback;

  UserAddressesScreenArguments({required this.selectedCallback});
}

class AddressesScreen extends ScreenWidget {
  AddressesScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  AddressesScreenState createState() => AddressesScreenState(context);
}

class AddressesScreenState extends BaseStateArgumentObject<AddressesScreen,
    AddressesViewModel, UserAddressesScreenArguments> {
  AddressesScreenState(BuildContext context)
      : super(() => AddressesViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.addressesTitle)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: AlignmentDirectional.topEnd,
              child: TextButton.icon(
                  onPressed: () {
                    showPopUpDialog(context,
                        saveChanges: viewModel.saveAddressChanges);
                  },
                  icon: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  label: Text(
                    strings.getStrings(AllStrings.addressesTitle),
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  )),
            ),
            Expanded(
              child: StreamBuilder<List<UserAddress>?>(
                  stream: viewModel.userAddresses,
                  builder: (context, snapshot) {
                    if (snapshot.data == null) {
                      return const Center(child: MainLoadinIndicatorWidget());
                    }
                    return snapshot.data!.isNotEmpty
                        ? ListView(
                            children: snapshot.data!.reversed
                                .map((e) => AddressCardWidget(
                                    onTap: () => viewModel.makePrimary(e),
                                    address: e,
                                    isSelectionAvailable: true,
                                    selected: args == null
                                        ? null
                                        : () => viewModel.selectAddress(e),
                                    onEdit: (address) => showPopUpDialog(
                                        context,
                                        address: address,
                                        saveChanges:
                                            viewModel.saveAddressChanges),
                                    onDelete: viewModel.deleteAddress))
                                .toList(),
                          )
                        : Center(
                            child: Text(
                              strings
                                  .getStrings(AllStrings.yourListIsEmptyTitle),
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          );
                  }),
            ),
            if (args == null)
              const SizedBox()
            else
              Directionality(
                textDirection: useLanguage == Languages.arabic.name
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                child: DottedBorder(
                  radius: const Radius.circular(10),
                  color: Colors.grey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: Colors.orange,
                            size: 15,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              strings.getStrings(AllStrings
                                  .pleaseSelectAnAddressToContinueTitle),
                              style: const TextStyle(
                                  color: Colors.orange, fontSize: 16),
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void showPopUpDialog(BuildContext context,
      {UserAddress? address, required void Function(UserAddress) saveChanges}) {
    showDialog(
        barrierDismissible: true,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: StreamBuilder<bool?>(
                stream: viewModel.addressState,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    if (snapshot.data!) {
                      return const Center(child: MainLoadinIndicatorWidget());
                    }
                    Navigator.of(context).pop();
                  }
                  return CustomAddressDialogWidget(
                    countryList: const ["Country 1", "Country 2"],
                    cityList: const ["City 1", "City 2"],
                    regionList: const ["Region 1", "Region 2"],
                    userAddress: address,
                    onSaveChanges: saveChanges,
                  );
                }),
          );
        });
  }
}
