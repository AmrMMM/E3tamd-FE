import 'package:flutter/cupertino.dart';

import '../DI.dart';
import '../screens/end_user_phase/settings/settings_screen.dart';

class AgentCategory {
  int id;
  IconData iconData;
  String nameAr;
  String nameEn;

  AgentCategory(
      {required this.id,
      required this.nameAr,
      required this.nameEn,
      required this.iconData});

  String getName() {
    if (useLanguage == Languages.arabic.name) {
      return nameAr;
    } else {
      return nameEn;
    }
  }
}
