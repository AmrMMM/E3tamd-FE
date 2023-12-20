import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customalertdialog/custom_alert_dialog.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/main_login_screen_viewmodel.dart';

class MainLoginScreen extends ScreenWidget {
  MainLoginScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  MainLoginScreenState createState() => MainLoginScreenState(context);
}

class MainLoginScreenState
    extends BaseStateObject<MainLoginScreen, MainLoginScreenViewModel> {
  MainLoginScreenState(BuildContext context)
      : super(() => MainLoginScreenViewModel(context));

  final formKey = GlobalKey<FormState>();

  final IStrings _strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _username = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
    viewModel.isLoginErrd.listen((event) {
      if (event != null && event == true) {
        showDialog(
            barrierDismissible: true,
            useSafeArea: false,
            context: context,
            builder: (context) => Dialog(
                  child: CustomAlertDialogWidget(
                      aknowledgeOnly: true,
                      title: _strings.getStrings(AllStrings.loginTitle),
                      description:
                          currentAuthenticationMode == AuthMode.phoneNumber
                              ? _strings.getStrings(
                                  AllStrings.phoneOrPasswordAreIncorrectTitle)
                              : _strings.getStrings(
                                  AllStrings.emailOrPassowrdAreIncorrectTitle),
                      onPositivePressed: () => Navigator.of(context).pop()),
                ));
      }
    });
  }

  // StreamBuilder<bool?>(
  // stream: viewModel.isLoginErrd,
  // builder: (context, snapshot) {
  // return snapshot.data != null && snapshot.data!
  // ? Center(
  // child: Text(
  // currentAuthenticationMode == AuthMode.phoneNumber
  // ? _strings.getStrings(
  // AllStrings.phoneOrPasswordAreIncorrectTitle)
  //     : _strings.getStrings(AllStrings
  //     .emailOrPassowrdAreIncorrectTitle),
  // style: const TextStyle(
  // color: Colors.red, fontWeight: FontWeight.bold),
  // ),
  // )
  //     : const SizedBox();
  // },
  // ),

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListView(children: [
              Image.asset(
                'assets/logo_colored.png',
                width: 250,
                height: 250,
              ),
              if (currentAuthenticationMode == AuthMode.email)
                PrimaryTextFieldWithHeader(
                  inputType: InputType.email,
                  hintText: _strings.getStrings(AllStrings.emailTitle),
                  isObscure: false,
                  isRequired: true,
                  onChangedValue: (value) {
                    setState(() {
                      _username = value;
                    });
                  },
                )
              else
                PrimaryTextFieldWithHeader(
                  inputType: InputType.phone,
                  hintText: _strings.getStrings(AllStrings.phoneNumberTitle),
                  isObscure: false,
                  isRequired: true,
                  onChangedValue: (value) {
                    setState(() {
                      _username = value;
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
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("/forgotPassword");
                  },
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
              PrimaryButtonShape(
                  width: double.infinity,
                  text: _strings.getStrings(AllStrings.loginTitle),
                  color: const Color.fromRGBO(43, 162, 129, 1),
                  stream: viewModel.loading,
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      await viewModel.loginWithPhoneAndPassword(
                          _username, _password);
                    }
                  }),
              Center(
                child: InkWell(
                  onTap: () => viewModel.navigateToRegisterScreen(),
                  child: RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: _strings
                              .getStrings(AllStrings.dontHaveAccountTitle),
                          style: const TextStyle(color: Colors.black)),
                      TextSpan(
                          text:
                              ' ${_strings.getStrings(AllStrings.registerNowTitle)}',
                          style: const TextStyle(color: Colors.greenAccent)),
                    ]),
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
