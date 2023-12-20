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
    _offers.add(await logic.getOffers());
  }
}
