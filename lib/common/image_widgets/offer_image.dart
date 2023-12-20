import 'package:e3tmed/common/image_widgets/HTTPImage.dart';
import 'package:e3tmed/models/offer.dart';
import 'package:flutter/material.dart';

class OfferImage extends StatelessWidget {
  final Offer offer;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? fit;

  const OfferImage(
      {super.key,
      required this.offer,
      this.width,
      this.height,
      this.color,
      this.fit});

  @override
  Widget build(BuildContext context) {
    return HTTPImage(
      "Product/Offer/Image",
      queryArgs: {"offerId": offer.id},
      width: width,
      height: height,
      color: color,
      fit: fit,
    );
  }
}
