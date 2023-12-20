// ignore_for_file: no_logic_in_create_state

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/about_view_model.dart';

class AboutScreen extends ScreenWidget {
  AboutScreen(BuildContext context) : super(context);

  @override
  AboutScreenState createState() => AboutScreenState(context);
}

class AboutScreenState extends BaseStateObject<AboutScreen, AboutViewModel> {
  AboutScreenState(BuildContext context) : super(() => AboutViewModel(context));

  final string = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(string.getStrings(AllStrings.aboutTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ListView(
            children: [
              Image.asset(
                'assets/logo_colored.png',
                width: 100,
                height: 100,
              ),
              Text(
                string
                    .getStrings(AllStrings.aboutMessageTile),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      viewModel.openSocialMedia("facebook");
                    },
                    child: Image.asset(
                      "assets/facebook_logo.png",
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      viewModel.openSocialMedia("instagram");
                    },
                    child: Image.asset(
                      "assets/instagram_logo.png",
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      viewModel.openSocialMedia("twitter");
                    },
                    child: Image.asset(
                      "assets/twitter_logo.png",
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
