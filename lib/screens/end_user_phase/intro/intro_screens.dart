// ignore_for_file: no_logic_in_create_state

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/buttons/primarybuttonshape.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../viewmodels/end_user_viewmodels/intro_screen_view_model.dart';

class IntroScreen extends ScreenWidget {
  IntroScreen(BuildContext context) : super(context);

  @override
  IntroScreenState createState() => IntroScreenState(context);
}

class IntroScreenState extends BaseStateObject<IntroScreen, IntroViewModel> {
  IntroScreenState(BuildContext context) : super(() => IntroViewModel(context));

  List<PageViewModel> pageViewModelList = [
    PageViewModel(
      titleWidget: const Text(
        "Doors & Windows Installation ",
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      bodyWidget: const Text(
        "Lorem Ipsum is simply dummy text of  the printing and typesetting industry.",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      image: SizedBox(
        width: 134,
        height: 148,
        child: Image.asset('assets/window.png'),
      ),
    ),
    PageViewModel(
      titleWidget: const Text(
        "Doors & Windows Installation ",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      bodyWidget: const Text(
        "Lorem Ipsum is simply dummy text of  the printing and typesetting industry.",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      image: SizedBox(
          width: 134, height: 148, child: Image.asset('assets/door.png')),
    ),
    PageViewModel(
      titleWidget: const Text(
        "Doors & Windows Installation ",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      bodyWidget: const Text(
        "Lorem Ipsum is simply dummy text of  the printing and typesetting industry.",
        style: TextStyle(color: Colors.white, fontSize: 14),
      ),
      image: SizedBox(
        width: 134,
        height: 148,
        child: Image.asset('assets/gear.png'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(43, 162, 129, 1),
              Color.fromRGBO(18, 0, 66, 1),
            ],
          ),
        ),
        child: IntroductionScreen(
          globalBackgroundColor: Colors.transparent,
          pages: pageViewModelList,
          done: PrimaryButtonShape(
            width: 90,
            text: 'Done',
            color: Theme.of(context).colorScheme.secondary,
            stream: null,
            onTap: () => viewModel.goToLoginSignUpScreen(),
          ),
          onDone: () => viewModel.goToLoginSignUpScreen(),
          next: PrimaryButtonShape(
            width: 90,
            text: 'Next',
            color: Theme.of(context).colorScheme.secondary,
            stream: null,
            onTap: () {},
          ),
          skip: PrimaryButtonShape(
            width: 90,
            text: 'Skip',
            color: Colors.transparent,
            stream: null,
            onTap: () => viewModel.goToLoginSignUpScreen(),
          ),
          showSkipButton: true,
          showDoneButton: true,
          showNextButton: false,
          isBottomSafeArea: true,
        ),
      ),
    );
  }
}
