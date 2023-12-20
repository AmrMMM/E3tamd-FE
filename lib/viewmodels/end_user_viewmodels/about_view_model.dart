import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutViewModel extends BaseViewModel {
  AboutViewModel(BuildContext context) : super(context);

  void openSocialMedia(String socialMedia) async {
    if (await canLaunchUrl(Uri.parse("https://twitter.com/?lang=en"))) {
      await launchUrl(Uri.parse("https://twitter.com/?lang=en"));
    } else {
      throw "Could not launch browser";
    }
  }
}
