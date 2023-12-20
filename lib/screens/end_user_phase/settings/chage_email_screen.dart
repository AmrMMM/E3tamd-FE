import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../viewmodels/end_user_viewmodels/change_email_view_model.dart';

class ChangeEmailScreen extends ScreenWidget {
  ChangeEmailScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  ChangeEmailScreenState createState() => ChangeEmailScreenState(context);
}

class ChangeEmailScreenState
    extends BaseStateObject<ChangeEmailScreen, ChangeEmailViewModel> {
  ChangeEmailScreenState(BuildContext context)
      : super(() => ChangeEmailViewModel(context));
  final formKey = GlobalKey<FormState>();
  final strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String email = "", confirmEmail = "";

  @override
  void initState() {
    super.initState();
    viewModel.userEmail.listen((event) {
      setState(() {
        if (event) {
          Fluttertoast.showToast(
              msg: strings.getStrings(AllStrings.emailChangedSuccessfullyTitle),
              gravity: ToastGravity.BOTTOM);
          Navigator.pop(context);
        } else if (!event) {
          Fluttertoast.showToast(
              msg: strings.getStrings(AllStrings.errorWhileChangingEmailTitle),
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
        title: Text(strings.getStrings(AllStrings.changeEmailTitle)),
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
                              strings.getStrings(AllStrings.newEmailTitle),
                          isObscure: false,
                          isRequired: true,
                          onChangedValue: (value) => setState(() {
                                email = value;
                              }),
                          inputType: InputType.email),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.changeEmailTitle),
                    color: Theme.of(context).primaryColor,
                    stream: viewModel.loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        viewModel.updateUserEmail(email);
                      }
                      // }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
