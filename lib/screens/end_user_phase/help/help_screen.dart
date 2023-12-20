// ignore_for_file: no_logic_in_create_state

import 'dart:async';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:e3tmed/common/customtextfield/CustomTextField.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/help_view_model.dart';

class HelpScreen extends ScreenWidget {
  HelpScreen(BuildContext context) : super(context);

  @override
  HelpScreenState createState() => HelpScreenState(context);
}

class HelpScreenState extends BaseStateObject<HelpScreen, HelpViewModel> {
  HelpScreenState(BuildContext context) : super(() => HelpViewModel(context));

  final formKey = GlobalKey<FormState>();
  final string = Injector.appInstance.get<IStrings>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  UserAuthModel? auth;

  String name = "";
  String email = "";
  String message = "";

  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = viewModel.auth.listen((event) {
      setState(() {
        auth = event;
      });
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
      appBar: AppBar(
        title: Text(string.getStrings(AllStrings.helpTitle)),
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
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${string.getStrings(AllStrings.helloTitle)} ${auth?.name}",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            InkWell(
                              onTap: () async => await viewModel
                                  .contactViaWhatsapp(supportWhatsAppNumber),
                              child: Image.asset(
                                "assets/whatsapp_logo.png",
                                width: 30,
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          string.getStrings(AllStrings.instructionsTitle),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListView(
                      children: [
                        PrimaryTextFieldWithHeader(
                            hintText: string.getStrings(AllStrings.nameTitle),
                            isObscure: false,
                            isRequired: true,
                            onChangedValue: (value) {
                              setState(() {
                                name = value;
                              });
                            },
                            inputType: InputType.name),
                        PrimaryTextFieldWithHeader(
                            hintText: string.getStrings(AllStrings.emailTitle),
                            isObscure: false,
                            isRequired: true,
                            onChangedValue: (value) {
                              setState(() {
                                email = value;
                              });
                            },
                            inputType: InputType.email),
                        PrimaryTextFieldWithHeader(
                            hintText:
                                string.getStrings(AllStrings.messageTitle),
                            isObscure: false,
                            isRequired: true,
                            onChangedValue: (value) {
                              setState(() {
                                message = value;
                              });
                            },
                            inputType: InputType.longText),
                      ],
                    ),
                  ),
                ),
                PrimaryButtonShape(
                    width: double.infinity,
                    text: string.getStrings(AllStrings.sendTitle),
                    color: Theme.of(context).primaryColor,
                    stream: viewModel.loading,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        viewModel.sendMessage(name, email, message);
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
