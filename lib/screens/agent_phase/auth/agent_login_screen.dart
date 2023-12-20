import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/auth/agent_login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/buttons/primarybuttonshape.dart';
import '../../../common/customtextfield/CustomTextField.dart';
import '../../../logic/interfaces/IStrings.dart';

class AgentLoginScreen extends ScreenWidget {
  AgentLoginScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  AgentLoginScreenState createState() => AgentLoginScreenState(context);
}

class AgentLoginScreenState
    extends BaseStateObject<AgentLoginScreen, AgentViewModel> {
  AgentLoginScreenState(BuildContext context)
      : super(() => AgentViewModel(context));
  final formKey = GlobalKey<FormState>();

  final IStrings _strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String _phoneNumber = "";
  String _password = "";
  bool isClickable = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(children: [
              const SizedBox(
                height: 70,
              ),
              Image.asset(
                'assets/logo_colored.png',
                width: 182,
                height: 182,
              ),
              StreamBuilder<bool?>(
                stream: viewModel.isLoginErrd,
                builder: (context, snapshot) {
                  return snapshot.data != null && !snapshot.data!
                      ? const Center(
                          child: Text(
                            'Login error, please try again',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        )
                      : const SizedBox();
                },
              ),
              PrimaryTextFieldWithHeader(
                inputType: InputType.phone,
                hintText: _strings.getStrings(AllStrings.phoneNumberTitle),
                isObscure: false,
                isRequired: true,
                onChangedValue: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
              ),
              PrimaryTextFieldWithHeader(
                inputType: InputType.password,
                hintText: _strings.getStrings(AllStrings.passwordTitle),
                isObscure: true,
                isRequired: true,
                onChangedValue: (value) {
                  setState(() {
                    _password = value;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              PrimaryButtonShape(
                  width: double.infinity,
                  text: _strings.getStrings(AllStrings.loginTitle),
                  color: const Color.fromRGBO(43, 162, 129, 1),
                  stream: viewModel.loading,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      await viewModel.loginWithPhoneAndPassword(
                          _phoneNumber, _password);
                    }
                  }),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () =>
                      {Navigator.of(context).pushNamed("/aForgotPassword")},
                  child: Text(
                    _strings.getStrings(AllStrings.forgotPasswordTitle),
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
