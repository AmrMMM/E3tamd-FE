import 'package:e3tmed/logic/interfaces/core_logic.dart';
import 'package:e3tmed/models/offer.dart';
import 'package:e3tmed/viewmodels/baseViewModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class OffersViewModel extends BaseViewModelWithLogic<ICoreLogic> {
  OffersViewModel(BuildContext context) : super(context) {
    _init();
  }

  final _offers = BehaviorSubject<List<Offer>?>.seeded(null);

  Stream<List<Offer>?> get offers => _offers;

  void _init() async {
    try {
      _offers.add(await logic.getOffers());
    } catch (e) {
      // Transport/backend failure: surface it so the screen shows error + retry
      // instead of a silent empty list.
      _offers.addError(e);
    }
  }

  void retry() {
    _offers.add(null); // back to the loading state
    _init();
  }
}
