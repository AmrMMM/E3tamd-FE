import 'dart:async';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/viewmodels/agent_viewmodels/profile/agent_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/customalertdialog/custom_alert_dialog.dart';
import '../../../common/customtextfield/CustomTextField.dart';
import '../../../common/dropdownmenu/field_drop_down_menu.dart';
import '../../../common/profile_card/profile_card.dart';
import '../../../common/profilesection/profile_sections_widget.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../models/user_auth_model.dart';
import '../../end_user_phase/settings/settings_screen.dart';

class AgentProfileScreen extends ScreenWidget {
  AgentProfileScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  AgentProfileScreenState createState() => AgentProfileScreenState(context);
}

class AgentProfileScreenState
    extends BaseStateObject<AgentProfileScreen, AgentProfileViewModel> {
  AgentProfileScreenState(BuildContext context)
      : super(() => AgentProfileViewModel(context));
  StreamSubscription? _subscription;
  final strings = Injector.appInstance.get<IStrings>();
  UserAuthModel? _auth;

  @override
  void initState() {
    super.initState();
    _subscription = viewModel.auth.listen((event) {
      setState(() {
        _auth = event;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strings.getStrings(AllStrings.profileTitle)),
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
            const SizedBox(
              height: 20,
            ),
            ProfileSectionWidget(
                label: strings.getStrings(AllStrings.passwordTitle),
                iconData: Icons.lock_outline,
                onTap: () =>
                    Navigator.of(context).pushNamed("/aChangePasswordScreen")),
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
