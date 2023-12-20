import 'package:e3tmed/logic/interfaces/IAuth.dart';
import 'package:e3tmed/logic/interfaces/IStrings.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';
import 'package:rxdart/rxdart.dart';

class CompleteRegisterArgs {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String phone;
  final String country;
  final String city;
  final String region;
  final String address;

  CompleteRegisterArgs(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.phone,
      required this.country,
      required this.city,
      required this.region,
      required this.address});
}

class CompleteRegisterViewModel extends BaseViewModelWithLogic<IAuth> {
  CompleteRegisterViewModel(BuildContext context) : super(context);
  final strings = Injector.appInstance.get<IStrings>();
  final BehaviorSubject<bool?> _loading = BehaviorSubject.seeded(null);
  final BehaviorSubject<String?> _isRegisteredErrd =
      BehaviorSubject.seeded(null);

  Stream<bool?> get loading => _loading;

  Stream<String?> get isRegisteredErrd => _isRegisteredErrd;

  Future<void> registerAccountWithCompleteArgs(
      CompleteRegisterArgs args) async {
    _loading.add(true);
    final response = await logic.register(
        args.firstName,
        args.lastName,
        args.email,
        args.password,
        args.phone,
        args.country,
        args.city,
        args.region,
        args.address);
    if (response.success) {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, '/verifyUsername', (value) => true);
      _isRegisteredErrd.add(null);
    } else {
      if (response.emailConflict && response.phoneConflict) {
        _isRegisteredErrd.add(
            strings.getStrings(AllStrings.emailAndPhoneAreAlreadyExistTitle));
      } else if (response.emailConflict) {
        _isRegisteredErrd
            .add(strings.getStrings(AllStrings.emailIsAlreadyExistTitle));
      } else if (response.phoneConflict) {
        _isRegisteredErrd
            .add(strings.getStrings(AllStrings.phoneIsAlreadyExistTitle));
      }
    }
    _loading.add(false);
  }
}
