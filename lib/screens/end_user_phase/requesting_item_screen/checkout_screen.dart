import 'dart:async';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/address_card/address_card.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/custom_checkout_item_card/custom_order_item_widget.dart';
import 'package:e3tmed/common/customalertdialog/add_payment_popup.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/order.dart';
import 'package:e3tmed/models/user_address.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/customalertdialog/change_phone_dialog.dart';
import '../../../common/customalertdialog/customeaddressedialog.dart';
import '../../../common/main_loading.dart';
import '../../../common/price_summary_widget.dart';
import '../../../viewmodels/end_user_viewmodels/checkout_view_model.dart';

class CheckoutScreenArgs {
  final List<OrderItem> orderItems;

  CheckoutScreenArgs({required this.orderItems});
}

class CheckoutScreen extends ScreenWidget {
  CheckoutScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  CheckoutScreenState createState() => CheckoutScreenState(context);
}

class CheckoutScreenState extends BaseStateArgumentObject<CheckoutScreen,
    CheckoutViewModel, CheckoutScreenArgs> {
  CheckoutScreenState(BuildContext context)
      : super(() => CheckoutViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();
  final formKey = GlobalKey<FormState>();
  double totalPrice = 0;
  UserAuthModel? _auth;
  bool agree = false;
  late StreamSubscription sub;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    sub = viewModel.auth.listen((event) {
      setState(() {
        _auth = event;
        totalPrice = args!.orderItems
                .map((e) => e.totalPrice! * e.quantity)
                .reduce((value, element) => value + element) +
            VAT;
        viewModel.order.phoneNumber = _auth!.phone!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    sub.cancel();
  }

  @override
  Widget build(BuildContext context) {
    viewModel.onUpdateAddressCard();
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          strings.getStrings(AllStrings.continueCheckoutTitle),
        ),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...(args!.orderItems
                    .expand((e) => [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OrderItemWidget(
                              orderItem: e,
                              displayDetails: true,
                              isImageRemovable: false,
                              hasImagesSize: 55,
                            ),
                          ),
                        ])
                    .toList()),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 1, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: strings.getStrings(AllStrings.phoneNumberTitle),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        const TextSpan(
                            text: " *", style: TextStyle(color: Colors.red))
                      ])),
                      InkWell(
                        onTap: () {
                          // showPopUpDialog(context,
                          //     saveChanges: viewModel.saveAddressChanges);
                          showChangePhonePopupDialog(context,
                              saveChanges: (value) {
                            viewModel.order.phoneNumber = value;
                          });
                        },
                        child: Text(
                          strings.getStrings(AllStrings.changePhoneNumberTitle),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: PrimaryTextFieldWithHeader(
                      isObscure: false,
                      isRequired: true,
                      fixedValue: viewModel.order.phoneNumber,
                      isEditable: false,
                      onChangedValue: (value) {
                        // setState(() {
                        //   value.isNotEmpty
                        //       ? phoneNumber = value
                        //       : phoneNumber = "${_auth?.phone}";
                        // });
                      },
                      inputType: InputType.phone),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: strings.getStrings(AllStrings.addressesTitle),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        const TextSpan(
                            text: " *", style: TextStyle(color: Colors.red))
                      ])),
                      InkWell(
                        onTap: () {
                          // showPopUpDialog(context,
                          //     saveChanges: viewModel.saveAddressChanges);
                          viewModel.navigateToAddressScreen();
                        },
                        child: Text(
                          strings.getStrings(AllStrings.changeAddressTitle),
                          style: const TextStyle(
                              fontSize: 14, color: Colors.blueAccent),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: StreamBuilder<UserAddress?>(
                      stream: viewModel.selectedUserAddress,
                      builder: (context, snapshot) {
                        if (snapshot.data == null) {
                          return Center(
                              child: Text(
                            strings.getStrings(AllStrings.yourListIsEmptyTitle),
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ));
                        }
                        return AddressCardWidget(
                            address: snapshot.data!,
                            onEdit: (address) {},
                            onDelete: (address) {
                              viewModel.deleteAddress(address);
                            });
                      }),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    thickness: 0.7,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                          text: !viewModel.isBankCardPayment
                              ? strings
                                  .getStrings(AllStrings.paymentMethodCashTitle)
                              : strings.getStrings(
                                  AllStrings.paymentMethodCardTitle),
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ])),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: TextButton(
                          onPressed: () => showAddPaymentDialog(context),
                          child: Text(
                            strings.getStrings(AllStrings.changePaymentTitle),
                            style: const TextStyle(
                                fontSize: 14, color: Colors.blueAccent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: PriceSummaryWidget(
                    orderItems: args!.orderItems,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: Divider(
                    thickness: 0.7,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 15),
                  child: Text(
                    strings.getStrings(AllStrings.termAndConditionsTitle),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    strings.getStrings(AllStrings
                        .priceMayChangeAccordingToAgentsVisitAndFeesWillBeDeductedFromTotalPaymentWhenTheRequestIsCompletedTitle),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Material(
                        child: Checkbox(
                          activeColor: Theme.of(context).colorScheme.secondary,
                          value: agree,
                          onChanged: (value) {
                            setState(() {
                              agree = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      strings.getStrings(AllStrings
                          .iHaveReadAndAcceptedTermAdnConditionsTitle),
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: PrimaryButtonShape(
                      width: double.infinity,
                      text: strings.getStrings(AllStrings.confirmOrderTitle),
                      color: Theme.of(context).colorScheme.secondary,
                      stream: viewModel.addressState,
                      clickable: !agree,
                      onTap: () => agree ? viewModel.makeOrder() : null),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showChangePhonePopupDialog(BuildContext context,
      {required void Function(String) saveChanges}) {
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
                  return ChangePhoneNumberDialog(
                    title: '',
                    description: '',
                    onChangePressed: (value) {
                      Navigator.of(context).pop();
                      setState(() {
                        viewModel.order.phoneNumber = value;
                      });
                    },
                  );
                }),
          );
        });
  }

  void showAddPaymentDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              child: AddPaymentPopUpDialog(
                order: viewModel.order,
                paymentCallback: (isCardPayment) {
                  viewModel.setPaymentMode(isCardPayment);
                  setState(() {});
                },
              ),
            ));
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
