import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/profile/agent_changepassword_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/buttons/primarybuttonshape.dart';
import '../../../common/customtextfield/CustomTextField.dart';

class AgentChangePasswordScreen extends ScreenWidget {
  AgentChangePasswordScreen(BuildContext context) : super(context);

  @override
  AgentChangePasswordScreenState createState() =>
      AgentChangePasswordScreenState(context);
}

class AgentChangePasswordScreenState extends BaseStateObject<
    AgentChangePasswordScreen, AgentChangePasswordViewModel> {
  AgentChangePasswordScreenState(BuildContext context)
      : super(() => AgentChangePasswordViewModel(context));
  final formKey = GlobalKey<FormState>();
  final strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String currentPassword = "", newPassword = "", confirmPassword = "";

  @override
  void initState() {
    super.initState();
    viewModel.userPassword.listen((event) {
      setState(() {
        if (event != null && event) {
          Fluttertoast.showToast(
              msg: "Password changes successfully",
              gravity: ToastGravity.BOTTOM);
          Navigator.pop(context);
        } else if (event != null && !event) {
          Fluttertoast.showToast(
              msg: "Error while changing password",
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
                    color: Theme.of(context).colorScheme.secondary,
                    stream: viewModel.loading,
                    onTap: () async {
                      if (confirmPassword != newPassword) {
                        Fluttertoast.showToast(
                            msg: "password and confirm password dont match",
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
