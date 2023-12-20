import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../common/buttons/primarybuttonshape.dart';
import '../../../viewmodels/end_user_viewmodels/login_screen_viewmodel.dart';

class LoginSignUpScreen extends ScreenWidget {
  LoginSignUpScreen(BuildContext context) : super(context);

  @override
  // ignore: no_logic_in_create_state
  LoginSignUpScreenState createState() => LoginSignUpScreenState(context);
}

class LoginSignUpScreenState
    extends BaseStateObject<LoginSignUpScreen, LoginSignUpScreenViewModel> {
  LoginSignUpScreenState(BuildContext context)
      : super(() => LoginSignUpScreenViewModel(context));

  final IStrings _strings = Injector.appInstance.get<IStrings>();

  // String _language = "english.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 50),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Expanded(
              child: SizedBox(),
            ),
            Image.asset(
              'assets/logo_colored.png',
              width: 182,
              height: 182,
            ),
            const Text(
              'Doors & Windows Repair Services',
              style: TextStyle(
                color: Color.fromRGBO(31, 32, 36, 1),
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                'Lorem Ipsum is simply dummy text of\nthe printing and typesetting industry. ',
                style: TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
            const Expanded(
              child: SizedBox(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                PrimaryButtonShape(
                    width: 165,
                    text: _strings.getStrings(AllStrings.registerTitle),
                    color: Theme.of(context).primaryColor,
                    stream: null,
                    onTap: () => viewModel.navigateToRout('/register')),
                PrimaryButtonShape(
                    width: 165,
                    text: _strings.getStrings(AllStrings.loginTitle),
                    color: Theme.of(context).colorScheme.secondary,
                    stream: null,
                    onTap: () => viewModel.navigateToRout('/mainLogin')),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
