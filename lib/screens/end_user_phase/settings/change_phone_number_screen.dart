import 'dart:async';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/change_phone_number_view_model.dart';
import '../auth/verify_username_screen.dart';

class ChangePhoneNumberScreen extends ScreenWidget {
  ChangePhoneNumberScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  ChangePhoneNumberScreenState createState() =>
      // ignore: no_logic_in_create_state
      ChangePhoneNumberScreenState(context);
}

class ChangePhoneNumberScreenState extends BaseStateObject<
    ChangePhoneNumberScreen, ChangePhoneNumberViewModel> {
  ChangePhoneNumberScreenState(BuildContext context)
      : super(() => ChangePhoneNumberViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String? phoneNumber;
  UserAuthModel? _auth;

  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = viewModel.auth.listen((event) {
      setState(() {
        _auth = event;
      });
    });
    viewModel.userPassword.listen((event) {
      setState(() {
        if (event) {
          Fluttertoast.showToast(
              msg: strings
                  .getStrings(AllStrings.phoneNumberChangedSuccessfullyTitle),
              gravity: ToastGravity.BOTTOM);
          Navigator.pop(context);
        } else if (!event) {
          Fluttertoast.showToast(
              msg: strings
                  .getStrings(AllStrings.errorWhileChangingPhoneNumberTitle),
              gravity: ToastGravity.BOTTOM);
        }
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
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.changePhoneNumberTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      PrimaryTextFieldWithHeader(
                          hintText:
                              strings.getStrings(AllStrings.phoneNumberTitle),
                          isObscure: false,
                          isRequired: false,
                          isEditable: false,
                          fixedValue: _auth?.phone.toString(),
                          onChangedValue: (value) {},
                          inputType: InputType.phone),
                      const SizedBox(
                        height: 10,
                      ),
                      PrimaryTextFieldWithHeader(
                          hintText: strings
                              .getStrings(AllStrings.newPhoneNumberTitle),
                          isObscure: false,
                          isRequired: true,
                          onChangedValue: (value) => setState(() {
                                phoneNumber = value;
                              }),
                          inputType: InputType.phone),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.changePhoneNumberTitle),
                    color: Theme.of(context).primaryColor,
                    stream: viewModel.loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        viewModel.updatePhoneNumber(phoneNumber!);
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
