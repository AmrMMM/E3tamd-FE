// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/register_screen_viewmodel.dart';

class RegisterScreen extends ScreenWidget {
  RegisterScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  RegisterScreenState createState() => RegisterScreenState(context);
}

class RegisterScreenState
    extends BaseStateObject<RegisterScreen, RegisterScreenViewModel> {
  RegisterScreenState(BuildContext context)
      : super(() => RegisterScreenViewModel(context));

  final formKey = GlobalKey<FormState>();

  final IStrings _strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _phoneNumber = '';
  String _password = '';
  String _email = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          // appBar: AppBar(
          //   backgroundColor: Colors.white,
          //   elevation: 0,
          // ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView(children: [
                Image.asset(
                  'assets/logo_colored.png',
                  width: 250,
                  height: 250,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _strings.getStrings(AllStrings.createNewAccountTitle),
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24),
                      ),
                      Container(),
                    ],
                  ),
                ),
                PrimaryTextFieldWithHeader(
                  inputType: InputType.email,
                  hintText: _strings.getStrings(AllStrings.emailTitle),
                  isObscure: false,
                  isRequired: true,
                  onChangedValue: (value) {
                    setState(() {
                      _email = value;
                    });
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
                PrimaryTextFieldWithHeader(
                  inputType: InputType.password,
                  hintText:
                      _strings.getStrings(AllStrings.confirmPasswordTitle),
                  isObscure: true,
                  isRequired: true,
                  onChangedValue: (value) {
                    _confirmPassword = value;
                  },
                ),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: _strings.getStrings(AllStrings.nextTitle),
                    color: const Color.fromRGBO(43, 162, 129, 1),
                    stream: null,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        if (_password == _confirmPassword) {
                          viewModel.NavigateToCompletePhase(RegisterScreenArgs(
                              email: _email,
                              phone: _phoneNumber,
                              password: _password));
                        } else {
                          Fluttertoast.showToast(
                              msg: _strings.getStrings(AllStrings
                                  .passwordAndConfirmPasswordDoesntMatchTitle),
                              gravity: ToastGravity.BOTTOM);
                        }
                      }
                    }),
                Center(
                  child: InkWell(
                    onTap: () => {viewModel.NavigateToRout('/mainLogin')},
                    child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: _strings
                                .getStrings(AllStrings.alreadyUserTitle),
                            style: const TextStyle(color: Colors.black)),
                        TextSpan(
                            text:
                                ' ${_strings.getStrings(AllStrings.loginNowTitle)}',
                            style: const TextStyle(color: Colors.greenAccent)),
                      ]),
                    ),
                  ),
                ),
              ]),
            ),
          )),
    );
  }
}
