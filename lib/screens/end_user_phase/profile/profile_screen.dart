// ignore_for_file: no_logic_in_create_state

import 'dart:async';

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/models/user_auth_model.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/profile_card/profile_card.dart';
import '../../../common/profilesection/profile_sections_widget.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/profile_view_model.dart';

class ProfileScreen extends ScreenWidget {
  ProfileScreen(BuildContext context) : super(context);

  @override
  ProfileScreenState createState() => ProfileScreenState(context);
}

class ProfileScreenState
    extends BaseStateObject<ProfileScreen, ProfileViewModel> {
  ProfileScreenState(BuildContext context)
      : super(() => ProfileViewModel(context));

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
        title: Text(strings.getStrings(AllStrings.profileTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCardWidget(auth: _auth),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: ListView(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    children: [
                      ProfileSectionWidget(
                          label: strings.getStrings(AllStrings.offersTitle),
                          iconData: Icons.local_offer_outlined,
                          onTap: () => viewModel.navigateToPage("/offers")),
                      ProfileSectionWidget(
                          label: strings.getStrings(AllStrings.myOrdersTitle),
                          iconData: Icons.card_travel_outlined,
                          onTap: () => viewModel.navigateToPage('/myOrders')),
                      ProfileSectionWidget(
                          label: strings.getStrings(AllStrings.helpTitle),
                          iconData: Icons.help_outline,
                          onTap: () => viewModel.navigateToPage("/help")),
                      ProfileSectionWidget(
                          label: strings.getStrings(AllStrings.aboutTitle),
                          iconData: Icons.info_outline,
                          onTap: () => viewModel.navigateToPage("/about")),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
