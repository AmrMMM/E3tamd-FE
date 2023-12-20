// ignore_for_file: use_build_context_synchronously

import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/logic/interfaces/support.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

import '../../logic/interfaces/ISocial.dart';
import '../../models/user_auth_model.dart';

class HelpViewModel extends BaseViewModelWithLogic<ISupport> {
  HelpViewModel(BuildContext context) : super(context);

  final _auth = Injector.appInstance.get<IAuth>();
  final _social = Injector.appInstance.get<ISocial>();
  final strings = Injector.appInstance.get<IStrings>();

  final BehaviorSubject<bool> _loading = BehaviorSubject.seeded(false);

  Stream<bool> get loading => _loading;

  Stream<UserAuthModel?> get auth => _auth.authData;

  contactViaWhatsapp(String phoneNumber) async {
    await _social.contactViaWhatsApp(phoneNumber);
  }

  Future<bool> sendMessage(String name, String email, String message) async {
    _loading.add(true);
    final response = await logic.makeSupportRequest(name, email, message);
    if (response) {
      Fluttertoast.showToast(
          msg: strings.getStrings(AllStrings.thanksForContactingUsTitle),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
          msg: strings.getStrings(AllStrings.failedToSendMessageTitle),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
    _loading.add(false);
    return response;
  }
}
