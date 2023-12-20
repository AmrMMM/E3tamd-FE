import 'package:e3tmed/common/image_widgets/offer_image.dart';
import 'package:e3tmed/models/offer.dart';
import 'package:flutter/material.dart';

class OfferCardItemWidget extends StatelessWidget {
  final Offer offer;
  final void Function(Offer) onTap;

  const OfferCardItemWidget(
      {Key? key, required this.offer, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap(offer),
      child: Card(
        elevation: 2,
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.all(5.0),
                child: OfferImage(offer: offer, width: 90, height: 90)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    offer.getMessageName(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 14),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    "Valid till ${offer.validTill}",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ),
                if (offer.getProductName() != "*")
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "${offer.getProductName()}${offer.getManufacturerName() == "*" ? "" : " by ${offer.getManufacturerName()}"}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 13),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "${offer.getManufacturerName() == "*" ? "" : "${offer.getManufacturerName()} -> "}${offer.getCategoryName() == "*" ? "All categories" : offer.getCategoryName()}",
                      style: TextStyle(
                          color: Theme.of(context).primaryColor, fontSize: 13),
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
