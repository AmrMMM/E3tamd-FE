import 'package:e3tmed/logic/interfaces/IConfiguration.dart';
import 'package:e3tmed/models/terms_and_conditions.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:injector/injector.dart';

class TermsAndConditionsViewModel extends BaseViewModel {
  TermsAndConditionsViewModel(BuildContext context) : super(context);

  final _configuration = Injector.appInstance.get<IConfiguration>();

  Future<TermsAndConditions?> getTermsAndConditions() {
    return _configuration.getTermsAndConditions();
  }
}
