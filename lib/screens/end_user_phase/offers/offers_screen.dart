// ignore_for_file: no_logic_in_create_state

import 'package:e3tmed/common/BaseWidgets.dart';
import 'package:e3tmed/common/offercarditem/offer_card_item.dart';
import 'package:e3tmed/models/offer.dart';
import 'package:flutter/material.dart';
import 'package:injector/injector.dart';

import '../../../DI.dart';
import '../../../common/main_loading.dart';
import '../../../logic/interfaces/IStrings.dart';
import '../../../viewmodels/end_user_viewmodels/offers_view_model.dart';

class OffersScreen extends ScreenWidget {
  OffersScreen(BuildContext context) : super(context);

  @override
  OffersScreenState createState() => OffersScreenState(context);
}

class OffersScreenState extends BaseStateObject<OffersScreen, OffersViewModel> {
  OffersScreenState(BuildContext context)
      : super(() => OffersViewModel(context));

  final string = Injector.appInstance.get<IStrings>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(string.getStrings(AllStrings.offersTitle)),
      ),
      body: Directionality(
        textDirection:
            useLanguage == 'arabic' ? TextDirection.rtl : TextDirection.ltr,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: StreamBuilder<List<Offer>?>(
              stream: viewModel.offers,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const Center(child: MainLoadinIndicatorWidget());
                }
                return snapshot.data!.isNotEmpty
                    ? ListView(
                        children: snapshot.data!
                            .map((e) => OfferCardItemWidget(
                                  offer: e,
                                  onTap: (offer) {},
                                ))
                            .toList(),
                      )
                    : Center(
                        child: Text(
                          string.getStrings(AllStrings.yourListIsEmptyTitle),
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      );
              }),
        ),
      ),
    );
  }
}
