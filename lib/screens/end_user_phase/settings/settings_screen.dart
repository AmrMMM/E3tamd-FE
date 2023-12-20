import 'dart:async';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/profile_card/profile_card.dart';
import 'package:e3tmed/common/profilesection/profile_sections_widget.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/customalertdialog/custom_alert_dialog.dart';
import '../../../common/dropdownmenu/field_drop_down_menu.dart';
import '../../../models/user_auth_model.dart';
import '../../../viewmodels/end_user_viewmodels/settings_view_model.dart';

class SettingsScreen extends ScreenWidget {
  SettingsScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  SettingsScreenState createState() => SettingsScreenState(context);
}

class SettingsScreenState
    extends BaseStateObject<SettingsScreen, SettingsViewModel> {
  SettingsScreenState(BuildContext context)
      : super(() => SettingsViewModel(context));

  final strings = Injector.appInstance.get<IStrings>();

  UserAuthModel? _auth;

  late StreamSubscription sub;

  @override
  void initState() {
    super.initState();
    sub = viewModel.auth.listen((event) {
      setState(() {
        _auth = event;
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
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.settingsTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ProfileCardWidget(auth: _auth),
            ),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.changeNameTitle),
                iconData: Icons.person_outline,
                onTap: () => viewModel.navigateToRout("/accountInformation")),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.addressesTitle),
                iconData: Icons.location_on_outlined,
                onTap: () => viewModel.navigateToRout("/addresses")),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.changePasswordTitle),
                iconData: Icons.lock_outline,
                onTap: () => viewModel.navigateToRout("/changePassword")),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.changePhoneNumberTitle),
                iconData: Icons.local_phone_outlined,
                onTap: () => viewModel.navigateToRout("/changePhoneNumber")),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.changeEmailTitle),
                iconData: Icons.mail_outline,
                onTap: () => viewModel.navigateToRout("/changeEmail")),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.changeLanguageTitle),
                iconData: Icons.language_outlined,
                onTap: () => showChangePopUpDialog(context)),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.logoutTitle),
                iconData: Icons.logout,
                onTap: () => showPopUpDialog(context)),
          ],
        ),
      ),
    );
  }

  void showPopUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        useSafeArea: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: CustomAlertDialogWidget(
              title: strings.getStrings(AllStrings.logoutTitle),
              description:
                  strings.getStrings(AllStrings.areYouSureYouWantToLogoutTitle),
              onPositivePressed: () {
                viewModel.logoutUser();
              },
            ),
          );
        });
  }

  showChangePopUpDialog(BuildContext context) => showDialog(
        builder: (context) => Directionality(
          textDirection:
              useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
          child: Dialog(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    strings.getStrings(AllStrings.changeLanguageTitle),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                            child: FieldDropDownMenu(
                          isRequired: false,
                          items: [
                            Languages.arabic.name,
                            Languages.english.name
                          ],
                          onChanged: (index, value) {
                            if (useLanguage != Languages.values[index].name) {
                              viewModel.changeTheCurrentLanguage(
                                  Languages.values[index]);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          hintText: '',
                          fixedValue: useLanguage,
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        context: context,
      );
}

enum Languages { arabic, english }
