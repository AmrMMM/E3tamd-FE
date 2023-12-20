import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../viewmodels/end_user_viewmodels/account_information_view_model.dart';

class AccountInformationScreen extends ScreenWidget {
  AccountInformationScreen(BuildContext context) : super(context);

  @override
  AccountInformationScreenState createState() =>
      // ignore: no_logic_in_create_state
      AccountInformationScreenState(context);
}

class AccountInformationScreenState extends BaseStateObject<
    AccountInformationScreen, AccountInformationViewModel> {
  AccountInformationScreenState(BuildContext context)
      : super(() => AccountInformationViewModel(context));
  final formKey = GlobalKey<FormState>();
  final strings = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  String firstName = "";
  String lastName = "";

  @override
  void initState() {
    super.initState();
    viewModel.userFirstAndLastName.listen((event) {
      setState(() {
        if (event) {
          Fluttertoast.showToast(
              msg: strings.getStrings(AllStrings.nameChangedSuccessfullyTitle),
              gravity: ToastGravity.BOTTOM);
          Navigator.pop(context);
        } else if (!event) {
          Fluttertoast.showToast(
              msg: strings.getStrings(AllStrings.errorWhileChangingNameTitle),
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
        title: Text(strings.getStrings(AllStrings.changeNameTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                StreamBuilder<UserAuthModel?>(
                    stream: viewModel.userData,
                    builder: (context, snapshot) {
                      return Column(children: [
                        PrimaryTextFieldWithHeader(
                            hintText:
                                strings.getStrings(AllStrings.firstNameTitle),
                            initialValue: snapshot.data?.firstName,
                            isObscure: false,
                            isRequired: true,
                            onChangedValue: (value) => setState(() {
                                  firstName = value;
                                }),
                            inputType: InputType.name),
                        PrimaryTextFieldWithHeader(
                            hintText:
                                strings.getStrings(AllStrings.lastNameTitle),
                            initialValue: snapshot.data?.lastName,
                            isObscure: false,
                            isRequired: true,
                            onChangedValue: (value) => setState(() {
                                  lastName = value;
                                }),
                            inputType: InputType.name),
                      ]);
                    }),
                const Expanded(child: SizedBox()),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: strings.getStrings(AllStrings.changeNameTitle),
                    color: Theme.of(context).primaryColor,
                    stream: viewModel.loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        viewModel.updateUserFirstAndLastName(
                            firstName, lastName);
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
