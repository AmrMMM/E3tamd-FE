abstract class ISocial {
  Future<void> contactWithPhoneNumber(String phoneNumber);

  Future<void> openSocialMediaLink(String link);

  Future<void> contactViaWhatsApp(String phoneNumber);
}
