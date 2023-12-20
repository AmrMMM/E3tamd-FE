import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/auth/agent_forgotpassword_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/buttons/primarybuttonshape.dart';
import '../../../common/customtextfield/CustomTextField.dart';

class AgentForgotPasswordScreen extends ScreenWidget {
  AgentForgotPasswordScreen(BuildContext context) : super(context);

  @override
  AgentForgotPasswordScreenState createState() =>
      // ignore: no_logic_in_create_state
      AgentForgotPasswordScreenState(context);
}

class AgentForgotPasswordScreenState extends BaseStateObject<
    AgentForgotPasswordScreen, AgentForgotPasswordViewModel> {
  AgentForgotPasswordScreenState(BuildContext context)
      : super(() => AgentForgotPasswordViewModel(context));
  final formKey = GlobalKey<FormState>();
  final strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String code = "";
  String phoneNumber = "";
  String newPassword = "";

  @override
  void initState() {
    super.initState();
    viewModel.isPasswordChanged.listen((event) {
      if (event) {
        Navigator.of(context, rootNavigator: true)
            .popAndPushNamed("/mainLogin");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: scaffoldKey,
        body: Form(
          key: formKey,
          child: Padding(
            padding:
                const EdgeInsets.only(top: 40, left: 15, right: 15, bottom: 15),
            child: ListView(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/logo_colored.png',
                  width: 182,
                  height: 182,
                ),
                Text(
                  strings.getStrings(AllStrings.forgotPasswordTitle),
                  style: const TextStyle(
                    color: Color.fromRGBO(31, 32, 36, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  strings.getStrings(AllStrings
                      .enterYourPhoneNumberToReceiveTheValidationCodeTitle),
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
                              PrimaryTextFieldWithHeader(
                                  hintText: strings
                                      .getStrings(AllStrings.phoneNumberTitle),
                                  isObscure: false,
                                  isRequired: true,
                                  onChangedValue: (value) => setState(() {
                                        phoneNumber = value;
                                      }),
                                  inputType: InputType.phone),
                              const SizedBox(
                                height: 30,
                              ),
                              PrimaryButtonShape(
                                  width: double.infinity,
                                  text: strings
                                      .getStrings(AllStrings.continueTitle),
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  stream: viewModel.loading,
                                  onTap: () {
                                    if (formKey.currentState!.validate()) {
                                      viewModel.verifyPhoneNumber(phoneNumber);
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
                                isObscure: false,
                                isRequired: true,
                                isEditable: true,
                                hintText: strings
                                    .getStrings(AllStrings.receivedCodeTitle),
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
                                    "you will be receiving the code in ",
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
                                          ? Text("${snapshot.data} seconds",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary))
                                          : InkWell(
                                              onTap: () =>
                                                  viewModel.verifyPhoneNumber(
                                                      phoneNumber),
                                              child: Text("resend code again",
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
                                      .getStrings(AllStrings.continueTitle),
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
