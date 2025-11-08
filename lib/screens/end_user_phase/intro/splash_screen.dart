import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injector/injector.dart';
import 'package:url_launcher/url_launcher.dart' as LaunchReview;

import '../../../common/customalertdialog/custom_alert_dialog.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/splash_screen_viewmodel.dart';

class SplashScreen extends ScreenWidget {
  SplashScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  SplashScreenState createState() => SplashScreenState(context);
}

class SplashScreenState
    extends BaseStateObject<SplashScreen, SplashScreenViewModel> {
  SplashScreenState(BuildContext context)
      : super(() => SplashScreenViewModel(context));

  final _strings = Injector.appInstance.get<IStrings>();

  @override
  void initState() {
    super.initState();
    viewModel.splashScreenHandler();
    viewModel.isNewVersion.listen((event) {
      if (event == true) {
        showDialog(
            barrierDismissible: true,
            useSafeArea: false,
            context: context,
            builder: (context) => Dialog(
                  child: CustomAlertDialogWidget(
                      aknowledgeOnly: true,
                      title: _strings.getStrings(AllStrings.newVersionTitle),
                      description: _strings.getStrings(AllStrings
                          .aNewVersionHasBeenReleasedPleaseUpdateTitle),
                      onPositivePressed: () {
                        LaunchReview.launchUrl(Uri.parse('https://play.google.com/store/apps/details?id=com.e3tmed'));
                        SystemChannels.platform
                            .invokeMethod('SystemNavigator.pop');
                      }),
                ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(43, 162, 129, 1),
              Color.fromRGBO(18, 0, 66, 1),
            ],
          )),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 50),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo-etmed.gif',
                      color: Colors.white,
                      width: 182,
                      height: 182,
                    ),
                    const Text(
                      'Doors & Windows Repair\nServices',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
