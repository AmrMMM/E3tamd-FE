// ignore_for_file: no_logic_in_create_state

import 'dart:async';

import 'package:e3tmed/DI.dart';
import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/screens/end_user_phase/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../viewmodels/end_user_viewmodels/forgot_password_viewmodel.dart';

class ForgotPasswordScreen extends ScreenWidget {
  ForgotPasswordScreen(BuildContext context) : super(context);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState(context);
}

class ForgotPasswordScreenState
    extends BaseStateObject<ForgotPasswordScreen, ForgotPasswordViewModel> {
  ForgotPasswordScreenState(BuildContext context)
      : super(() => ForgotPasswordViewModel(context));
  final formKey = GlobalKey<FormState>();
  final strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String code = "";
  String userName = "";
  String newPassword = "";

  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = viewModel.isPasswordChanged.listen((event) {
      if (event) {
        Navigator.of(context, rootNavigator: true)
            .popAndPushNamed("/mainLogin");
      }
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
      body: Form(
        key: formKey,
        child: Directionality(
          textDirection: useLanguage == Languages.arabic.name
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 15),
            child: ListView(
              children: [
                Image.asset(
                  'assets/logo_colored.png',
                  width: 182,
                  height: 182,
                ),
                const Text(
                  'Doors & Windows Repair Services',
                  style: TextStyle(
                    color: Color.fromRGBO(31, 32, 36, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  strings.getStrings(AllStrings
                      .youWillReceiveACodeToResetYourPasswordPleaseWriteItDownWhenYouReceiveItTitle),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                StreamBuilder<bool>(
                    stream: viewModel.isChangingPassword,
                    builder: (context, snapshot) => !snapshot.data!
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              if (currentAuthenticationMode == AuthMode.email)
                                PrimaryTextFieldWithHeader(
                                  key: const Key("EmailField"),
                                  hintText:
                                      strings.getStrings(AllStrings.emailTitle),
                                  isObscure: false,
                                  isRequired: true,
                                  onChangedValue: (value) => setState(() {
                                    userName = value;
                                  }),
                                  inputType: InputType.email,
                                )
                              else
                                PrimaryTextFieldWithHeader(
                                    key: const Key("PhoneField"),
                                    hintText: strings.getStrings(
                                        AllStrings.phoneNumberTitle),
                                    isObscure: false,
                                    isRequired: true,
                                    onChangedValue: (value) => setState(() {
                                          userName = value;
                                        }),
                                    inputType: InputType.phone),
                              PrimaryButtonShape(
                                  width: double.infinity,
                                  text: strings
                                      .getStrings(AllStrings.verifyTitle),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  stream: viewModel.loading,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      viewModel.verifyUsername(userName);
                                    }
                                  }),
                            ],
                          )
                        : Column(
                            children: [
                              const SizedBox(
                                height: 30,
                              ),
                              PrimaryTextFieldWithHeader(
                                key: const Key("CodeField"),
                                isObscure: false,
                                isRequired: true,
                                isEditable: true,
                                hintText: strings.getStrings(
                                    AllStrings.confirmationCodeTitle),
                                onChangedValue: (value) => setState(() {
                                  code = value;
                                }),
                                inputType: InputType.number,
                              ),
                              PrimaryTextFieldWithHeader(
                                isObscure: false,
                                isRequired: true,
                                isEditable: true,
                                hintText: strings
                                    .getStrings(AllStrings.newPasswordTitle),
                                onChangedValue: (value) => setState(() {
                                  newPassword = value;
                                }),
                                inputType: InputType.password,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: Row(children: [
                                  Text(
                                    strings.getStrings(AllStrings
                                        .youWillBeReceivingCodeInTitle),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  const SizedBox(
                                    width: 1,
                                  ),
                                  StreamBuilder<int>(
                                    stream: viewModel.secondsDelay,
                                    builder: (context, snapshot) {
                                      return snapshot.data != 0
                                          ? Text(
                                              "${snapshot.data} ${strings.getStrings(AllStrings.secondsTitle)}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary))
                                          : InkWell(
                                              onTap: () => viewModel
                                                  .verifyUsername(userName),
                                              child: Text(
                                                  strings.getStrings(AllStrings
                                                      .resendCodeAgainTitle),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary)),
                                            );
                                    },
                                  ),
                                ]),
                              ),
                              PrimaryButtonShape(
                                  width: double.infinity,
                                  text: strings
                                      .getStrings(AllStrings.submitTitle),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  stream: viewModel.loading,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      viewModel.confirmChangePassword(
                                          code, newPassword);
                                    }
                                  }),
                            ],
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
