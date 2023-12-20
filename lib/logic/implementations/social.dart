import 'package:e3tmed/logic/interfaces/ISocial.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialImplementation implements ISocial {
  @override
  Future<void> contactViaWhatsApp(String phoneNumber) async {
    var whatsapp = phoneNumber;
    var whatAppUrl = "https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    await launchUrl(Uri.parse(whatAppUrl),
        mode: LaunchMode.externalApplication);
  }

  @override
  Future<void> contactWithPhoneNumber(String phoneNumber) async {
    if (await canLaunchUrl(Uri.parse("tel://$phoneNumber"))) {
      await launchUrl(Uri.parse("tel://$phoneNumber"));
    } else {
      throw "Could not launch browser";
    }
  }

  @override
  Future<void> openSocialMediaLink(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(Uri.parse(link));
    } else {
      throw "Could not launch browser";
    }
  }
}
