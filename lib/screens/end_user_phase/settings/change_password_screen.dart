import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../viewmodels/end_user_viewmodels/change_password_view_model.dart';

class ChangePasswordScreen extends ScreenWidget {
  ChangePasswordScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  ChangePasswordScreenState createState() => ChangePasswordScreenState(context);
}

class ChangePasswordScreenState
    extends BaseStateObject<ChangePasswordScreen, ChangePasswordViewModel> {
  ChangePasswordScreenState(BuildContext context)
      : super(() => ChangePasswordViewModel(context));
  final strings = Injector.appInstance.get<IStrings>();
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String currentPassword = "", newPassword = "", confirmPassword = "";

  @override
  void initState() {
    super.initState();
    viewModel.userPassword.listen((event) {
      setState(() {
        if (event != null && event) {
          Fluttertoast.showToast(
              msg: strings
                  .getStrings(AllStrings.passwordChangedSuccessfullyTitle),
              gravity: ToastGravity.BOTTOM);
          Navigator.pop(context);
        } else if (event != null && !event) {
          Fluttertoast.showToast(
              msg: strings
                  .getStrings(AllStrings.errorWhileChangingPasswordTitle),
              gravity: ToastGravity.BOTTOM);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.changePasswordTitle)),
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
                          hintText: strings
                              .getStrings(AllStrings.currentPasswordTitle),
                          isObscure: true,
                          isRequired: true,
                          onChangedValue: (value) => setState(() {
                                currentPassword = value;
                              }),
                          inputType: InputType.password),
                      const SizedBox(
                        height: 10,
                      ),
                      PrimaryTextFieldWithHeader(
                          hintText:
                              strings.getStrings(AllStrings.newPasswordTitle),
                          isObscure: true,
                          isRequired: true,
                          onChangedValue: (value) => setState(() {
                                newPassword = value;
                              }),
                          inputType: InputType.password),
                      const SizedBox(
                        height: 10,
                      ),
                      PrimaryTextFieldWithHeader(
                          hintText: strings
                              .getStrings(AllStrings.confirmPasswordTitle),
                          isObscure: true,
                          isRequired: true,
                          onChangedValue: (value) => setState(() {
                                confirmPassword = value;
                              }),
                          inputType: InputType.password),
                    ],
                  ),
                ),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.changePasswordTitle),
                    color: Theme.of(context).primaryColor,
                    stream: viewModel.loading,
                    onTap: () async {
                      if (confirmPassword != newPassword) {
                        Fluttertoast.showToast(
                            msg: strings.getStrings(AllStrings
                                .passwordAndConfirmPasswordDoesntMatchTitle),
                            gravity: ToastGravity.BOTTOM);
                      } else {
                        if (formKey.currentState!.validate()) {
                          viewModel.updateUserPassword(
                              currentPassword, newPassword);
                        }
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
