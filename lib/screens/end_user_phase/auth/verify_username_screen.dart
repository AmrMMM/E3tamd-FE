// ignore_for_file: no_logic_in_create_state

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/viewmodels/end_user_viewmodels/verify_phone_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../logic/interfaces/IStrings.dart';

class VerifyUsernameArgs {
  final bool isRegister;

  VerifyUsernameArgs({required this.isRegister});
}

class VerifyUsernameScreen extends ScreenWidget {
  VerifyUsernameScreen(BuildContext context) : super(context);

  @override
  VerifyUsernameScreenState createState() => VerifyUsernameScreenState(context);
}

class VerifyUsernameScreenState extends BaseStateArgumentObject<
    VerifyUsernameScreen, VerifyUsernameViewModel, VerifyUsernameArgs> {
  VerifyUsernameScreenState(BuildContext context)
      : super(() => VerifyUsernameViewModel(context));
  final formKey = GlobalKey<FormState>();
  final strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String code = '';

  @override
  void initState() {
    super.initState();
    viewModel.initViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Form(
        key: formKey,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                    .youWillReceiveACodeToVerifyYourPhoneNumberPleaseWriteItDownWhenYouReceiveItTitle),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              PrimaryTextFieldWithHeader(
                  key: const Key("VerificationCodeField"),
                  hintText:
                      strings.getStrings(AllStrings.confirmationCodeTitle),
                  isObscure: false,
                  isRequired: true,
                  onChangedValue: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                  inputType: InputType.number),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(children: [
                  Text(
                    strings
                        .getStrings(AllStrings.youWillBeReceivingCodeInTitle),
                    style: TextStyle(
                        fontSize: 12, color: Theme.of(context).primaryColor),
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
                                  color:
                                      Theme.of(context).colorScheme.secondary))
                          : InkWell(
                              onTap: () => viewModel.initViewModel(),
                              child: Text(
                                  strings.getStrings(
                                      AllStrings.resendCodeAgainTitle),
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
                  text: strings.getStrings(AllStrings.verifyTitle),
                  color: Theme.of(context).colorScheme.secondary,
                  stream: viewModel.loading,
                  onTap: () {
                    if (formKey.currentState!.validate()) {
                      viewModel.verifyUsername(code);
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
